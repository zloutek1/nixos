{ config, pkgs, ... }: {

    home.username = "tomas";
    home.homeDirectory = "/home/tomas";

    home.packages = with pkgs; [
        # Applications
        brave
        obsidian

        # Coding
        vscode
    ];

    programs.git = {
        enable = true;
        userName = "Tomas Ljutenko";
        userEmail = "tomas.ljutenko@gmail.com";
    };

    programs.bash = {
        enable = true;
        enableCompletion = true;
        
        bashrcExtra = ''
        
        '';

        shellAliases = {
        
        };
    };

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "24.11";

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;


}