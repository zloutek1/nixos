{ pkgs, inputs, ... }: {

   home.packages = with pkgs; [
    hyprshade
  ];

  xdg.configFile."hypr/hyprshade.toml".text = ''
    [[shades]]
    name = "blue-light-filter"
    start_time = 19:00:00
    end_time = 06:00:00
  '';

}