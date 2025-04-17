{ pkgs, lib, hostname, ... }: 
let

  update-checker = pkgs.writeShellApplication {
    name = "update-checker";

    text = ''
      #!/usr/bin/env bash

      updates="$(cd ~/.config/nix && nix flake lock --update-input nixpkgs && nix build .#nixosConfigurations.${hostname}.config.system.build.toplevel && nvd diff /run/current-system ./result | grep -c -e '\[U')"

      alt="has-updates"
      if [ "$updates" -eq 0 ]; then
          alt="updated"
      fi

      tooltip="System updated"
      if [ "$updates" != 0 ]; then
        tooltip=$(cd ~/.config/nix && nvd diff /run/current-system ./result | grep -e '\[U' | awk '{ for (i=3; i<NF; i++) printf $i " "; if (NF >= 3) print $NF; }' ORS='\\n' )
      fi

      echo "{ \"text\":\"$updates\", \"alt\":\"$alt\", \"tooltip\":\"$tooltip\" }"
    '';
  };

in
{
    exec = "${lib.getExe update-checker}";
    on-click = "${lib.getExe update-checker} && notify-send 'The system has been updated'"; # refresh on click
    interval = 3600; # refresh every hour
    tooltip = true;
    return-type = "json";
    format = "{} {icon}";
    format-icons = {
        has-updates = ""; # icon when updates needed
        updated = ""; # icon when all packages updated
    };
}