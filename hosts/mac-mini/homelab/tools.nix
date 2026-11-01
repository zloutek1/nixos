# The operator's commands for the homelab (docs/homelab/operator.md). Stock
# tools do the rest: launchctl and /var/log/homelab here, systemd in the guest.
{ pkgs, ... }:
let
  vm = "system/org.nixos.homelab-vm";

  homelab-check = pkgs.writeShellApplication {
    name = "homelab-check";
    # check() calls the helper functions by name.
    excludeShellChecks = [ "SC2329" ];
    text = ''
      failed=0
      check() {
        local what=$1
        shift
        if "$@" > /dev/null 2>&1; then
          echo "✓ $what"
        else
          echo "✗ $what"
          failed=1
        fi
      }
      vm_running() { /bin/launchctl print ${vm} | grep -q 'state = running'; }
      limactl_allowed() {
        /usr/libexec/ApplicationFirewall/socketfilterfw --getappblocked /usr/local/libexec/homelab/limactl | grep -q permitted
      }
      disk_free() { [ "$(df -g / | awk 'NR == 2 { print $4 }')" -ge 20 ]; }

      echo "mac-mini"
      check "T7 mounted, with homelab/.t7-marker" test -e /Volumes/T7/homelab/.t7-marker
      check "VM daemon running" vm_running
      check "limactl on the firewall allow list" limactl_allowed
      check "rest-server listening on 127.0.0.1:8000" /usr/bin/nc -z 127.0.0.1 8000
      check "at least 20 GiB free on the internal disk" disk_free

      echo "homelab"
      if ! ssh -o ConnectTimeout=10 homelab homelab-guest-check; then
        failed=1
      fi
      exit "$failed"
    '';
  };

  homelab-reboot = pkgs.writeShellApplication {
    name = "homelab-reboot";
    text = ''
      if [ "$(id -u)" -ne 0 ]; then
        exec sudo "$0" "$@"
      fi
      case "''${1:-}" in
        "") reboot=(/sbin/shutdown -r now) ;;
        --update) reboot=(/usr/sbin/softwareupdate --install --all --restart) ;;
        *) echo "usage: homelab-reboot [--update]" >&2; exit 2 ;;
      esac

      # SIGTERM shuts the guest down cleanly, and nothing relaunches it.
      echo "stopping the VM"
      /bin/launchctl bootout ${vm} || true
      for _ in $(seq 120); do
        pgrep -u homelab -f com.apple.Virtualization.VirtualMachine > /dev/null || break
        sleep 1
      done
      if pgrep -u homelab -f com.apple.Virtualization.VirtualMachine > /dev/null; then
        echo "the VM is still running after 2 min; not rebooting" >&2
        exit 1
      fi
      echo "VM stopped; rebooting"
      "''${reboot[@]}"
    '';
  };
in
{
  environment.systemPackages = [
    homelab-check
    homelab-reboot
    pkgs.nixos-rebuild-ng # installs as nixos-rebuild
  ];

  # Admin goes in two hops: `ssh mac-mini`, then `ssh homelab`. Lima forwards
  # the guest's sshd to 127.0.0.1:60022; the alias keeps its host key apart
  # from anything else on that port.
  environment.etc."ssh/ssh_config.d/200-homelab.conf".text = ''
    Host homelab
      HostName 127.0.0.1
      Port 60022
      User tomas
      HostKeyAlias homelab
  '';

  # The guest builds itself; only the evaluation runs here.
  environment.shellAliases.rebuild-homelab = "nixos-rebuild switch --flake ~/nix-config#homelab --target-host homelab --build-host homelab --sudo";
}
