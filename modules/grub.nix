{ pkgs, ... }: {

    boot.loader.grub = {
        enable = true;
        efiSupport = true;
        # Tell GRUB to install to the ESP ($boot_efi_path from hardware-configuration.nix)
        # 'nodev' means use the ESP defined elsewhere (recommended for EFI)
        device = "nodev";
        # Enable os-prober to detect Windows
        useOSProber = true;
        # Optional: Set a theme
        theme = import ../pkgs/distro-grub-themes.nix { inherit pkgs; };
    };

    environment.systemPackages = with pkgs; [ os-prober ];

}