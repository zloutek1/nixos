# Join every saved network with the real Wi-Fi MAC, so the router's DHCP
# reservations match. The networks and their passwords (in the System keychain)
# are joined by hand once; no SSID is named here, since this flake is public.
#
# nix-darwin has no Wi-Fi options, and a configuration profile would need the
# passwords. Instead, set "Private Wi-Fi Address: Off" on every entry in the
# known-networks file. It takes effect on the next join, so a switch never drops
# the SSH session it runs over.
let
  plist = "/Library/Preferences/com.apple.wifi.known-networks.plist";
  buddy = "/usr/libexec/PlistBuddy";
in
{
  system.activationScripts.postActivation.text = ''
    # The plist holds binary data, so sed must not decode it as UTF-8.
    { ${buddy} -c Print ${plist} 2>/dev/null || true; } \
      | LC_ALL=C sed -n "s/^    \(wifi\.network\.ssid\.[^']*\) = Dict {$/\1/p" \
      | while IFS= read -r network; do
          key=":$network:PrivateMACAddressModeUserSetting"
          if ! mode=$(${buddy} -c "Print '$key'" ${plist} 2>/dev/null); then
            echo "wifi: no private-address setting for $network, skipping" >&2
          elif [ "$mode" != off ]; then
            ${buddy} -c "Set '$key' off" ${plist}
            echo "wifi: $network private address $mode -> off, applies on next join" >&2
          fi
        done
  '';
}
