{ pkgs, ... }: {

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 1d";
    };
  };

  # auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  programs.nix-index.enable = true;

}
