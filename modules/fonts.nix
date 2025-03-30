{ pkgs, ... }: {

    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
            noto-fonts
        ];
    };

}