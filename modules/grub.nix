{ pkgs, ... }: {

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
                
                useOSProber = true;
                
                ## APPEARANCE OPTIONS
                font                    = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
                fontSize                = 26;
                gfxmodeEfi              = "auto";
                gfxmodeBios             = "auto";

                theme = pkgs.stdenv.mkDerivation {
                    pname = "distro-grub-themes";
                    version = "3.2";
                    src = pkgs.fetchFromGitHub {
                        owner = "AdisonCavani";
                        repo = "distro-grub-themes";
                        rev = "v3.2";
                        #hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs="; #v3.1
                        hash = "sha256-U5QfwXn4WyCXvv6A/CYv9IkR/uDx4xfdSgbXDl5bp9M=";
                    };
                    installPhase = "mkdir -vp $out && tar -xf themes/nixos.tar -C $out/";
                };

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
