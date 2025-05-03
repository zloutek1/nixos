{ config, lib, ... }: 
{
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {

    wayland.windowManager.hyprland.settings = {
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      master = {
        new_status = "master";
      };
      
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };
    };

  };
}