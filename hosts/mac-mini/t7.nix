# External volumes don't mount until someone logs in at the console, and after
# a pre-boot SSH unlock nobody does. Mount the T7 by volume UUID instead, and
# keep retrying so a late or re-plugged disk is picked up too.
#
# Nothing searches the T7, so Spotlight indexing is kept off there; otherwise
# it would index every photo and world file as they land.
{ pkgs, ... }:
let
  uuid = "3F3B75F7-CE57-4793-9D3F-BA70914D9410";
in
{
  launchd.daemons.mount-t7 = {
    script = ''
      if ! /usr/sbin/diskutil info ${uuid} 2>/dev/null | grep -q 'Mounted: *Yes'; then
        /usr/sbin/diskutil mount ${uuid} || exit 1
      fi
      mountpoint=$(/usr/sbin/diskutil info ${uuid} | sed -n 's/^ *Mount Point: *//p')
      if /usr/bin/mdutil -s "$mountpoint" | grep -q 'Indexing enabled'; then
        /usr/bin/mdutil -i off "$mountpoint"
      fi
    '';
    serviceConfig = {
      RunAtLoad = true;
      StartInterval = 60;
      StandardOutPath = "/var/log/mount-t7.log";
      StandardErrorPath = "/var/log/mount-t7.log";
    };
  };
}
