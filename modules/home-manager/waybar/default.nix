{ pkgs, lib, hostname, ... }: 
let

  modules = import ./modules { inherit pkgs; };

  # Helper function to process a single bar
  processBar = config: allModules: barName:
    let 
      allModules = builtins.map (module: module barName) modules;
      allModuleNames = builtins.concatMap (config: builtins.attrNames config.programs.waybar.settings.${barName}) allModules;
      
      barConfig = config.programs.waybar.settings.${barName};
      moduleNames = barConfig.modules-left ++ barConfig.modules-center ++ barConfig.modules-right;
    
      missingModules = builtins.filter (name: !(builtins.elem name allModuleNames)) moduleNames;
    in
      if (missingModules == []) then 
        allModules 
      else 
        throw "Error: The following modules were requested but are not available: ${toString missingModules}";

  # Main function to create module configurations
  mkModuleConfigs = config: allModules:
    config.programs.waybar.settings
    |> builtins.attrNames
    |> map (processBar config allModules)
    |> builtins.concatLists;

  waybarConfig = {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          position = "top";
          spacing = 4;
          reload_style_on_change = true;

          modules-left = [ "custom/power" "clock" "custom/wallchange" "tray" ];
          modules-center = [ "hyprland/workspaces" ];
          modules-right = [ "pulseaudio" "backlight" "network" "bluetooth" "battery" ];
        };
      };

      style = builtins.readFile ./style.css;

    };

    home.activation.writeWaybarTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f $HOME/.config/waybar/colors.css ]; then
        cat "${./colors.css}" > "$HOME/.config/waybar/colors.css"
      fi
    '';
  };

in
  lib.mkMerge ([waybarConfig] ++ (mkModuleConfigs waybarConfig modules))