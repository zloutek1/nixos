{ inputs, lib, self }:

# Function to generate a Darwin system configuration.
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
    isLinux = false; isDarwin = true;
  };

  mkUserModule = username: {
    imports = [ ../users/${username}/darwin.nix ];
    _module.args = { inherit username; };
    
    home-manager.users.${username} = {
      imports = [
        self.homeModules.common
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
    self.darwinModules.common
    ../hosts/${hostname}/default.nix
    
    # Home Manager setup
    inputs.home-manager.darwinModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        extraSpecialArgs = commonArgs;
      };
    }

    # HomeBrew
    #inputs.nix-homebrew.darwinModules.nix-homebrew
    #{
    #  nix-homebrew = {
    #    enable = true;
    #    enableRosetta = true;
    #    user = "tomas";
    #    autoMigrate = true;
    #  };
    #}
  ];
in

inputs.nix-darwin.lib.darwinSystem {
  specialArgs = commonArgs;
  modules = modules ++ (map mkUserModule users) ++ extraModules;
}
