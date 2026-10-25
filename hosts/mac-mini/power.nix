# Never sleep; come back by itself after a power cut or a freeze.
# The screen still locks (it only blanks the console, services keep running).
{
  power = {
    sleep = {
      computer = "never";
      harddisk = "never";
      display = 10;
    };
    restartAfterPowerFailure = true;
    restartAfterFreeze = true;
  };

  networking.wakeOnLan.enable = true;

  # nix-darwin has no option for Power Nap.
  system.activationScripts.postActivation.text = ''
    pmset -a powernap 0
  '';

  system.defaults.screensaver = {
    askForPassword = true;
    askForPasswordDelay = 300;
  };
}
