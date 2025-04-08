{ inputs, self }:

{
    # Helper function to create systems with home-manager modules
    mkSystem = { system, hostName, userName, extraModules ? [] }:
        inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs self; };
            modules = [
                # Host-specific configuration
                ../hosts/${hostName}/default.nix
        
                # Common configuration
                ../modules/common.nix
        
                # Home Manager setup
                inputs.home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.backupFileExtension = "hm-backup";
                    home-manager.extraSpecialArgs = { inherit inputs self; };
                    home-manager.users.${userName} = import ../homes/${userName}/default.nix;
                }
        
            # Additional modules if needed
            ] ++ extraModules;
        };
}