# Join the saved networks with the real Wi-Fi MAC (4c:20:b8:e6:e5:a0) so the
# router's DHCP reservations match: 192.168.2.131 on The Mousy Connection
# (2.4 GHz, preferred), 192.168.1.131 on The Kitty Connection (5 GHz, fallback).
#
# nix-darwin has no Wi-Fi options, and a configuration profile would put the
# passwords in this public flake. Instead, set "Private Wi-Fi Address: Off" in
# the known-networks file; the networks themselves (and their passwords in the
# System keychain) are joined by hand once. It takes effect on the next join,
# so a switch never drops the SSH session it runs over.
{ lib, ... }:
let
  ssids = [
    "The Mousy Connection"
    "The Kitty Connection"
  ];
  plist = "/Library/Preferences/com.apple.wifi.known-networks.plist";
  buddy = "/usr/libexec/PlistBuddy";
in
{
  system.activationScripts.postActivation.text = lib.concatMapStrings (ssid: ''
    key=":wifi.network.ssid.${ssid}:PrivateMACAddressModeUserSetting"
    if ! mode=$(${buddy} -c "Print '$key'" ${plist} 2>/dev/null); then
      echo "wifi: no private-address setting for '${ssid}' (not joined yet?), skipping" >&2
    elif [ "$mode" != off ]; then
      ${buddy} -c "Set '$key' off" ${plist}
      echo "wifi: '${ssid}' private address $mode -> off, applies on next join" >&2
    fi
  '') ssids;
}
