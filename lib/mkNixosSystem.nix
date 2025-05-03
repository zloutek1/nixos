{ inputs, lib, self }:

# Function to generate a NixOS system configuration.
# Arguments:
#   - system: The os architecture (such as x86_64-linux)
#   - hostname: The name of the machine
#   - users: The names of the users on the machine
#   - extraModules: defining extra machine specific modules
{
  system,
  hostname,
  users,
  extraModules ? [ ],
}:

let
  userModules = map (username: {
    imports = [ ../users/${username}/nixos.nix ];
    _module.args = { inherit username; };
  }) users;

  mkHomeManager = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "hm-backup";
    home-manager.extraSpecialArgs = { 
      inherit inputs self lib hostname; 
      isUnstable = false; 
    };
    home-manager.users = lib.genAttrs users (username: {
      imports = [
        ../users/${username}/${hostname}.nix  
      ];
      _module.args = { inherit username; };
    });
  };

  modules = [
    # Host-specific variables
    {
      nixpkgs.hostPlatform = system;
    }

    # Overlays
    ../overlays

    # Host-specific modules
    self.nixosModules.common
    ../hosts/${hostname}/default.nix
    
    # Home Manager setup
    inputs.home-manager.nixosModules.home-manager 
    mkHomeManager
  ];
in

lib.nixosSystem {
  specialArgs = { inherit inputs self lib users hostname; };
  modules = modules ++ userModules ++ extraModules;
}
