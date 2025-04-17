{ pkgs, ... }: {
  "format" = "   ";
  "tooltip" = false;
  "on-click" = "${pkgs.wlogout}/bin/wlogout --protocol layer-shell";
}