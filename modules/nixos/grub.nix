{ self, pkgs, ... }:
{

  # WHENEVER THIS FILE CHANGES, ADD THIS FLAG TO YOUR REBUILD COMMAND: --install-bootloader

  boot = {
    tmp.cleanOnBoot = true;

    loader = {

      efi = {
        canTouchEfiVariables = true;
      };

      systemd-boot.enable = false;

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        default = "saved";

        useOSProber = true;

        theme = pkgs.elegant-grub-theme;

        extraEntries = ''
          submenu "Power Options" {
              menuentry "Reboot" {
                  reboot
              }

              menuentry "Poweroff" {
                  halt
              }

              menuentry "UEFI Firmware Settings" {
                  fwsetup
              }
          }
        '';
      };

    };
  };

  environment.systemPackages = with pkgs; [ os-prober ];

}
