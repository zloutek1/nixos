{ pkgs, self, username, ... }: {

    imports = [
        self.homeModules.cursor
        self.homeModules.dark-theme
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

}
