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
  commonArgs = {
    inherit inputs self lib hostname users;
    isLinux = true; isDarwin = false;
  };

  mkUserModule = username: {
    imports = [ ../users/${username}/nixos.nix ];
    _module.args = { inherit username; };
    
    home-manager.users.${username} = {
      imports = [
        self.homeModules.common
        self.homeModules.nixos
        ../users/${username}/${hostname}.nix 
      ];
      _module.args = { inherit username; };
    };
  };

  modules = [
    # Host-specific variables
    { nixpkgs.hostPlatform = system; }

    # Overlays
    ../overlays

    # Host-specific modules
    self.nixosModules.common
    ../hosts/${hostname}/default.nix
    
    # Home Manager setup
    inputs.home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        extraSpecialArgs = commonArgs;
      };
    }
  ];
in

lib.nixosSystem {
  specialArgs = commonArgs;
  modules = modules ++ (map mkUserModule users) ++ extraModules;
}
