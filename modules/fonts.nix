{ pkgs, ... }: {

    fonts = {
        enableDefaultPackages = true;
        fontconfig.enable = true;

        packages = with pkgs; [
            noto-fonts
            nerdfonts #(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];
    };

}
