{ pkgs }: {

    pkgs.stdenv.mkDerivation {
        pname = "distro-grub-themes-nixos"; # Slightly more specific name
        version = "3.1";

        src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
        };

        # Ensure we only copy the theme data needed by GRUB
        # The theme.txt should be at the root of the output path.
        installPhase = ''
            mkdir -p $out
            cp -r ${./customize/nixos}/* $out/  # Copy contents of nixos subdir to $out
        '';

        # Optional: Add metadata if you like
        meta = with pkgs.lib; {
            description = "Nixos GRUB theme from AdisonCavani/distro-grub-themes";
            homepage = "https://github.com/AdisonCavani/distro-grub-themes";
            license = licenses.gpl3Plus; # Check the actual license of the repo
            platforms = platforms.all;
        };

    }

}