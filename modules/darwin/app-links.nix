{ lib, config, pkgs, ... }: {

  # make aliases to /Applications to show the GUI apps in Spotlight
  system.activationScripts.applications = {
    text = let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
      targetDir = "/Applications/Nix Apps";
    in
    lib.mkForce ''
      echo "setting up ${targetDir}..." >&2
      rm -rf "${targetDir}"
      mkdir -p "${targetDir}"
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        if [[ "$src" == *.app && -d "$src" ]]; then
          app_name=$(basename "$src")
          echo "copying $app_name" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "${targetDir}/$app_name"
        fi
      done
    '';
  };
}
