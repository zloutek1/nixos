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
  inherit (cfg.storage) files marker;

  # Each probe is its own script, so shellcheck reads it at build time.
  probes = lib.mapAttrs (
    name: text:
    lib.getExe (
      pkgs.writeShellApplication {
        name = "check-${lib.strings.sanitizeDerivationName name}";
        inherit text;
      }
    )
  ) cfg.checks;

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
      ${lib.optionalString (
        marker != null
      ) "check \"storage marker visible (${marker})\" test -e ${marker}"}
      ${lib.concatStrings (
        lib.mapAttrsToList (name: probe: "check ${lib.escapeShellArg name} ${probe}\n") probes
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
        Per-service probes for homelab-guest-check, each run as root as its
        own shellchecked script.
        A probe passes when it exits 0; what it prints is shown next to it.
      '';
    };
    # Where services keep user files (photos, saves) and DB dumps. A host can
    # put them on an external volume; by default they stay on the system disk.
    storage = {
      files = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/homelab";
        example = "/mnt/t7";
        description = "Root of the services' user files and DB dumps (dumps under backups/db/<service>).";
      };
      marker = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/mnt/t7/.t7-marker";
        description = ''
          A file that exists only when the volume behind `files` is mounted. If
          set, storage units don't start without it, so an empty mountpoint is
          never written to.
        '';
      };
      dirs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "immich/library" ];
        description = "Folders under `files` that services need, created before each of their starts.";
      };
      units = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Services that use `files`. They wait for it, its folders and the marker.";
      };
    };
  };

  config = {
    environment.systemPackages = [ guestCheck ];

    systemd.services =
      let
        gate = {
          RequiresMountsFor = files;
        }
        // lib.optionalAttrs (marker != null) { ConditionPathExists = marker; };
      in
      {
        homelab-storage-dirs = {
          description = "Create the services' folders under ${files}";
          unitConfig = gate;
          # Not RemainAfterExit: it runs again before every start of a storage
          # unit, so a folder a restore didn't bring back (one that isn't backed
          # up) exists before systemd binds it into the unit.
          serviceConfig.Type = "oneshot";
          # On virtiofs, chown is ignored and every file looks owned by whoever
          # asks, so a plain mkdir is enough there.
          script = lib.concatMapStrings (dir: "mkdir -p ${files}/${dir}\n") cfg.storage.dirs;
        };
      }
      // lib.genAttrs cfg.storage.units (_: {
        after = [ "homelab-storage-dirs.service" ];
        requires = [ "homelab-storage-dirs.service" ];
        unitConfig = gate;
      });
  };
}
