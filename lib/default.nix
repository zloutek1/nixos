{ inputs, system }:

{
  # Helper function to create systems with home-manager modules
  mkSystem = { hostName, userName, extraModules ? [] }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
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
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.${userName} = import ../homes/${userName}/default.nix;
        }
        
        # Additional modules if needed
      ] ++ extraModules;
    };
}