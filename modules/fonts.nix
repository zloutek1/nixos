{ pkgs, ... }: {

    fonts = {
        enableDefaultPackages = true;
        fontconfig.enable = true;

        packages = with pkgs; [
            noto-fonts
            (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];
    };

}
