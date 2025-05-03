{ pkgs, ...}: barName: 

{
  
  programs.waybar.settings.${barName} = {
    "bluetooth" = {
      format-on = "󰂯";
      format-off = "BT-off";
      format-disabled = "󰂲";
      format-connected-battery = "{device_battery_percentage}% 󰂯";
      format-alt = "{device_alias} 󰂯";
      tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
      tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}\n{device_address}";
      tooltip-format-enumerate-connected-battery = "{device_alias}\n{device_address}\n{device_battery_percentage}%";
      on-click-right = "blueman-manager";
    };
  };

}