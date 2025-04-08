{ config, pkgs, ... }: {

    home.username = "tomas";
    home.homeDirectory = "/home/tomas";

    # Let Home Manager manage itself
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        # Applications
        brave
        chromium
        obsidian

        # Coding
        vscode
    ];

    programs.git = {
        enable = true;
        userName = "Tomas Ljutenko";
        userEmail = "tomas.ljutenko@gmail.com";
        extraConfig = {
            init.defaultBranch = "main";
            pull.rebase = true;
            rebase.autoStash = true;
        };
    };

    programs.bash = {
        enable = true;
        enableCompletion = true;
        
        bashrcExtra = ''
        
        '';

        shellAliases = {
        
        };
    };

    dconf.settings = {
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            enable-hot-corners = false;
            clock-show-weekday = true;
        };
        "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
            workspace-names = [ "Main" "Code" "Web" "Media" ];
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