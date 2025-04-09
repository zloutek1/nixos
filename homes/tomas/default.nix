{ pkgs, self, username, ... }: {

    imports = [
        "${self}/modules/home-manager/cursor.nix"
    ];

    home.username = username;
    home.homeDirectory = self.lib.getHomeDirectory { inherit pkgs username; };
    home.stateVersion = "24.11";

    # Let Home Manager manage itself
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        # Applications
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

}
