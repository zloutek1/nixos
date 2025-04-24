{ lib, ... }:
with lib;
let

  supported = {
    windowManagers = types.enum [ "hyprland" "none" ];
    shells = types.enum [ "zsh" "bash" ];
    terminals = types.enum [ "kitty" ];
    launchers = types.enum [ "rofi" "wofi" ];
    editors = types.enum [ "neovim" "vscode" ];
    browsers = types.enum [ "chromium" ]; 
  };

in
{
  
  options.preferences = {
    shells = lib.mkOption {
      type = mkSelectionType {
        name = "shell";
        type = supported.shells;
      };
      description = "Shell configuration with default selection";
    };
  };

}