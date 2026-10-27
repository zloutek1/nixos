# Desktop features a server doesn't use. Bluetooth (the keyboard and mouse)
# and AirDrop stay on.
#
# AirPlay Receiver listens on TCP 5000 and 7000, which self-hosted services
# often want. It and Handoff are per-host settings, which CustomUserPreferences
# can't write, so set them as the user and restart Control Center on a change.
# (macOS 27 spells the key "Receiver"; the older "Reciever" key is ignored.)
{ username, ... }:
let
  asUser = "launchctl asuser \"$(id -u -- ${username})\" sudo --user=${username} --";
in
{
  system.defaults.CustomUserPreferences = {
    "com.apple.assistant.support"."Assistant Enabled" = false;
    "com.apple.Siri" = {
      StatusMenuVisible = false;
      VoiceTriggerUserEnabled = false;
    };
  };

  system.activationScripts.postActivation.text = ''
    if [ "$(${asUser} defaults -currentHost read com.apple.controlcenter AirplayReceiverEnabled 2>/dev/null)" != 0 ]; then
      ${asUser} defaults -currentHost write com.apple.controlcenter AirplayReceiverEnabled -bool false
      killall ControlCenter 2>/dev/null || true
      echo "airplay: receiver turned off" >&2
    fi
    ${asUser} defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool false
    ${asUser} defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool false
  '';
}
