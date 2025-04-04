{ ... }: {

    boot.loader.grub = {
        enable = true;
        efiSupport = true;
        # Tell GRUB to install to the ESP ($boot_efi_path from hardware-configuration.nix)
        # 'nodev' means use the ESP defined elsewhere (recommended for EFI)
        device = "nodev";
        # Enable os-prober to detect Windows
        useOSProber = true;
        # Optional: Set a theme
        theme = pkgs.stdenv.mkDerivation {
            pname = "distro-grub-themes";
            version = "3.1";
            src = pkgs.fetchFromGitHub {
                owner = "AdisonCavani";
                repo = "distro-grub-themes";
                rev = "v3.1";
                hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
            };
            installPhase = "cp -r customize/nixos $out";
        };
    };

    environment.systemPackages = with pkgs; [ os-prober ];

}