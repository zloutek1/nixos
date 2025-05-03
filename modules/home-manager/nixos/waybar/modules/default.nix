{ pkgs, ... }:
[
  (import ./backlight.nix  { inherit pkgs; })
  (import ./battery.nix    { inherit pkgs; })
  (import ./bluetooth.nix  { inherit pkgs; })
  (import ./clock.nix      { inherit pkgs; })
  (import ./network.nix    { inherit pkgs; })
  (import ./power.nix      { inherit pkgs; })
  (import ./pulseaudio.nix { inherit pkgs; })
  (import ./tray.nix       { inherit pkgs; })
  (import ./wallchange.nix { inherit pkgs; })
  (import ./workspaces.nix { inherit pkgs; })
]