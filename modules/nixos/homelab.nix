# The homelab guest's own options, plus every service and group module.
# Every file in services/ and groups/ is imported; each service is off until a
# group (or the host) enables it. Adding a service: docs/homelab/operator.md.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab;
  t7 = (import ../../hosts/homelab/share.nix).mountPoint;
  marker = "${t7}/.t7-marker";

  guestCheck = pkgs.writeShellApplication {
    name = "homelab-guest-check";
    # check() calls `running` by name.
    excludeShellChecks = [ "SC2329" ];
    runtimeInputs = [
      pkgs.coreutils
      pkgs.systemd
    ];
    text = ''
      if [ "$(id -u)" -ne 0 ]; then
        exec sudo "$0" "$@"
      fi
      failed=0
      check() {
        local what=$1
        shift
        if out=$("$@" 2>&1); then
          echo "✓ $what''${out:+ ($out)}"
        else
          echo "✗ $what''${out:+: $out}"
          failed=1
        fi
      }
      running() {
        systemctl is-system-running > /dev/null ||
          { systemctl --failed --no-legend --plain | cut -d' ' -f1 | paste -sd' '; return 1; }
      }

      check "systemd running, no failed units" running
      check "T7 share visible (${marker})" test -e ${marker}
      ${lib.concatStrings (
        lib.mapAttrsToList (name: cmd: ''
          check ${lib.escapeShellArg name} ${pkgs.writeShellScript "check-${lib.strings.sanitizeDerivationName name}" cmd}
        '') cfg.checks
      )}
      exit "$failed"
    '';
  };
in
{
  imports =
    lib.filesystem.listFilesRecursive ./services ++ lib.filesystem.listFilesRecursive ./groups;

  options.homelab = {
    checks = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        immich = "curl -fsS http://127.0.0.1:2283/api/server/ping";
      };
      description = ''
        Per-service probes for homelab-guest-check, each run as root by bash.
        A probe passes when it exits 0; what it prints is shown next to it.
      '';
    };
    t7 = {
      dirs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "immich/library" ];
        description = "Folders under the T7 share that services need, created at boot.";
      };
      units = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Services that use the T7 share. They wait for it and its folders, and
          don't start without the marker, so an empty mountpoint is never written to.
        '';
      };
    };
  };

  config = {
    environment.systemPackages = [ guestCheck ];

    systemd.services = {
      homelab-t7-dirs = {
        description = "Create the services' folders on the T7 share";
        unitConfig = {
          RequiresMountsFor = t7;
          ConditionPathExists = marker;
        };
        # Not RemainAfterExit: it runs again before every start of a T7 unit,
        # so a folder a restore didn't bring back (one that isn't backed up)
        # exists before systemd binds it into the unit.
        serviceConfig.Type = "oneshot";
        # virtiofs ignores chown and reports every file as owned by whoever
        # asks, so a plain mkdir is enough.
        script = lib.concatMapStrings (dir: "mkdir -p ${t7}/${dir}\n") cfg.t7.dirs;
      };
    }
    // lib.genAttrs cfg.t7.units (_: {
      after = [ "homelab-t7-dirs.service" ];
      requires = [ "homelab-t7-dirs.service" ];
      unitConfig = {
        RequiresMountsFor = t7;
        ConditionPathExists = marker;
      };
    });
  };
}
