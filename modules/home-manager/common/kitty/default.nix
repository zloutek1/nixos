{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.programs.kitty.enable {
    programs.kitty = {
      # enable = true;
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
        listen_on = "unix:/tmp/kitty.sock";
      };
      extraConfig = ''
        include ./theme.conf
      '';
    };

    home.activation.writeKittyTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f $HOME/.config/kitty/theme.conf ]; then
        cat "${./theme.conf}" > "$HOME/.config/kitty/theme.conf"
      fi
    '';
  };
}
