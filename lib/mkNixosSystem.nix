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
  modules = [
    # Host-specific variables
    {
      nixpkgs.hostPlatform = system;
    }

    # Common configuration
    self.nixosModules.common

    # Host-specific configuration
    ../hosts/${hostname}/default.nix

    # Home Manager setup
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hm-backup";
      home-manager.extraSpecialArgs = { inherit inputs self lib hostname; };
      home-manager.users = lib.listToAttrs (map (username: {
        name = username;
        value = import ../homes/${username}/default.nix;
      }) users);
    }
  ];
in

lib.nixosSystem {
  specialArgs = { inherit inputs self lib users hostname; };
  modules = modules ++ extraModules;
}
