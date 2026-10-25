{
  # Upstream Nix, managed by nix-darwin.
  nix = {
    enable = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
