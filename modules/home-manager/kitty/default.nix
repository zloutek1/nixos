{ pkgs, ... }:
{

  #xdg.configFile."kitty/theme.conf" = {
  #  source = ./theme.conf;
  #};

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 16;
    };
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      mouse_hide_wait = "0.0";
      window_padding_width = 10;
      background_opacity = "0.9";
      background_blur = 5;

      # required to dynamically modify paddings, etc.
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty-rc";
    };
    extraConfig = ''
      include ./theme.conf
    '';
  };
}
