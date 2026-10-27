# Desktop features a server doesn't use. Bluetooth (the keyboard and mouse)
# and AirDrop stay on.
#
# Handoff is a per-host setting, which CustomUserPreferences can't write, so
# set it as the user.
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
    ${asUser} defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool false
    ${asUser} defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool false
  '';
}
