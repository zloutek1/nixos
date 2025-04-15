{ inputs, lib, self }:

# Function to generate a NixOS system configuration.
# Arguments:
#   - system: The os architecture (such as x86_64-linux)
#   - username: The name of the user
#   - hostname: The name of the machine
#   - extraModules: defining extra machine specific modules
{
  system,
  username,
  hostname,
  extraModules ? [ ],
}:

lib.nixosSystem {
  specialArgs = { inherit inputs self lib username; };
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
      home-manager.extraSpecialArgs = { inherit inputs self lib username; };
      home-manager.users.${username} = import ../homes/${username}/default.nix;
    }

    # Additional modules if needed
  ] ++ extraModules;
}
