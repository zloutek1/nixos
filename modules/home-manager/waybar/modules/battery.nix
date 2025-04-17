{
    interval =30;
    states = {
        good = 95;
        warning = 30;
        critical = 20;
    };
    format = "{capacity}% {icon}";
    format-charging = "{capacity}% 󰂄";
    format-plugged = "{capacity}% 󰂄 ";
    format-alt = "{time} {icon}";
    format-icons = [ "󰁻" "󰁼" "󰁾" "󰂀" "󰂂" "󰁹" ];
}