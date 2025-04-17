{ pkgs, lib, hostname, ... }:
{
  "custom/power" = import ./power.nix { inherit pkgs; };
  "clock" = import ./clock.nix;
  "tray" = import ./tray.nix;
  "hyprland/workspaces" = import ./workspaces.nix;
  "bluetooth" = import ./bluetooth.nix { inherit pkgs; };
  "network" = import ./wifi.nix { inherit pkgs; };
  "pulseaudio" = import ./pulseaudio.nix { inherit pkgs; };
  "battery" = import ./battery.nix;
  "backlight" = import ./backlight.nix;
}