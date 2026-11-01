# Restarts the VM daemon when launchd won't. A lost T7 kills the VM, but Lima's
# host agent stays up, so KeepAlive never fires; and the share doesn't come back
# after a replug until the VM restarts. The guest never remounts /mnt/t7 itself.
{ pkgs, ... }:
let
  label = "system/org.nixos.homelab-vm";
  marker = "${(import ../../homelab/share.nix).location}/.t7-marker";
  state = "/var/lib/homelab-watchdog";

  watchdog = pkgs.writeShellApplication {
    name = "homelab-watchdog";
    text = ''
      log() { echo "$(date '+%F %T') $*"; }

      restart() {
        now=$(date +%s)
        last=$(cat ${state}/last-restart 2>/dev/null || echo 0)
        if [ $((now - last)) -lt 600 ]; then
          log "would restart ($1), but the last restart was under 10 min ago"
          return
        fi
        log "restarting the VM: $1"
        echo "$now" > ${state}/last-restart
        rm -f ${state}/fails
        /bin/launchctl kickstart -k ${label}
      }

      mkdir -p ${state}

      # Booted out by homelab-reboot (or by hand): leave it down.
      if ! /bin/launchctl print ${label} > /dev/null 2>&1; then
        exit 0
      fi

      if [ ! -e ${marker} ]; then
        if [ ! -e ${state}/t7-lost ]; then
          log "T7 share is gone; waiting for it to come back"
          touch ${state}/t7-lost
        fi
        exit 0
      fi

      if [ -e ${state}/t7-lost ]; then
        rm -f ${state}/t7-lost
        restart "the T7 came back"
        exit 0
      fi

      # The guest's sshd answers with a banner; a dead VM doesn't, even though
      # Lima's host agent may still accept the connection.
      if [ "$(/usr/bin/nc -w 5 127.0.0.1 60022 < /dev/null 2> /dev/null | head -c 4)" = "SSH-" ]; then
        rm -f ${state}/fails
        exit 0
      fi

      fails=$(( $(cat ${state}/fails 2>/dev/null || echo 0) + 1 ))
      echo "$fails" > ${state}/fails
      log "no SSH banner from the guest ($fails in a row)"

      # Boot grace: a starting VM has no sshd for the first minute or so.
      pid=$(/bin/launchctl print ${label} | awk '$1 == "pid" { print $3 }')
      uptime=0
      if [ -n "$pid" ]; then
        started=$(date -j -f '%a %b %d %T %Y' "$(ps -o lstart= -p "$pid")" +%s)
        uptime=$(( $(date +%s) - started ))
      fi
      if [ "$fails" -ge 3 ] && [ "$uptime" -gt 300 ]; then
        restart "the guest looks dead"
      fi
    '';
  };
in
{
  launchd.daemons.homelab-watchdog = {
    serviceConfig = {
      ProgramArguments = [ "${watchdog}/bin/homelab-watchdog" ];
      RunAtLoad = true;
      StartInterval = 60;
      StandardOutPath = "/var/log/homelab/watchdog.log";
      StandardErrorPath = "/var/log/homelab/watchdog.log";
    };
  };
}
