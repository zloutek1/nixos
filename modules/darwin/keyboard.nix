{ lib, config, ... }: {

  system.keyboard.enableKeyMapping = true;

  system.defaults.NSGlobalDomain = {
    # keyboard navigation in dialogs
    AppleKeyboardUIMode = 3;

    # disable press-and-hold for keys in favor of key repeat
    ApplePressAndHoldEnabled = false;

    # fast key repeat rate when hold
    KeyRepeat = 2;
    InitialKeyRepeat = 15;
    
    # disable natural scrolling
    "com.apple.swipescrolldirection" = false;
  };
  
}