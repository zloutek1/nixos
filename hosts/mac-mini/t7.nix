# External volumes don't mount until someone logs in at the console, and after
# a pre-boot SSH unlock nobody does. Mount the T7 by volume UUID instead, and
# keep retrying so a late or re-plugged disk is picked up too.
{ pkgs, ... }:
let
  uuid = "3F3B75F7-CE57-4793-9D3F-BA70914D9410";
in
{
  launchd.daemons.mount-t7 = {
    script = ''
      if /usr/sbin/diskutil info ${uuid} 2>/dev/null | grep -q 'Mounted: *Yes'; then
        exit 0
      fi
      /usr/sbin/diskutil mount ${uuid}
    '';
    serviceConfig = {
      RunAtLoad = true;
      StartInterval = 60;
      StandardOutPath = "/var/log/mount-t7.log";
      StandardErrorPath = "/var/log/mount-t7.log";
    };
  };
}
