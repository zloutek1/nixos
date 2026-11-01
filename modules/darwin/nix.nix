{
  imports = [ ../common/nix.nix ];

  # Upstream Nix, managed by nix-darwin. nix-darwin's gc runs weekly by default.
  nix.enable = true;
}
