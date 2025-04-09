{ inputs, self }:

{
    # Helper function to create NixOS systems
    mkNixosSystem = { system, hostName, userName, extraModules ? [] }:
        inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs self userName; };
            modules = [
                # Host-specific variables
                {
                    nixpkgs.hostPlatform = system;
                
                    users.users.${userName} = {
                        isNormalUser = true;
                        description = "${userName}";
                        extraGroups = [ "wheel" "networkmanager" "video" ];
                    };
                }

                # Common configuration
                ../modules/common.nix
        
                # Host-specific configuration
                ../hosts/${hostName}/default.nix
        
                # Home Manager setup
                inputs.home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    # home-manager.backupFileExtension = "hm-backup";
                    home-manager.extraSpecialArgs = { inherit inputs self userName; };
                    home-manager.users.${userName} = import ../homes/${userName}/default.nix;
                }

            # Additional modules if needed
            ] ++ extraModules;
        };
}