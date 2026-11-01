# Nix settings both servers share (mac-mini and the homelab guest). Only options
# that exist under the same name in nix-darwin and NixOS go here.
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Collect on its own when a build runs low on space.
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 15 * 1024 * 1024 * 1024;
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
  };
}
