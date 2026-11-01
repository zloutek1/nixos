# The homelab guest's VM: a NixOS Lima-VZ instance that a launchd daemon runs
# as the hidden, non-admin homelab user. The guest's own config is hosts/homelab.
#
# The daemon execs a self-signed copy of limactl that holds the one Full Disk
# Access grant (for the T7 share and Rosetta). TCC matches the grant by signer,
# not by hash, so each new Lima build is re-signed with the same key and keeps it.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # Pinned on its own (see flake.nix); hosts/homelab/lima.nix must agree on the share.
  lima = inputs.nixpkgs-lima.legacyPackages.${pkgs.stdenv.hostPlatform.system}.lima;
  share = import ../../homelab/share.nix;
  instance = "homelab";
  home = "/var/lib/homelab";
  limaHome = "${home}/lima";

  stableLimactl = "/usr/local/libexec/homelab/limactl";
  signingCert = ./limactl-signing.pem;
  signingIdentity = "8F7E5F87A9A96888D316AC1B169A50B8CAFC88B0";
  # No hardened runtime: it would turn on library validation and reject Nix's
  # ad-hoc signed dylibs.
  entitlements = pkgs.writeText "limactl.entitlements" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0"><dict>
      <key>com.apple.security.network.client</key><true/>
      <key>com.apple.security.network.server</key><true/>
      <key>com.apple.security.virtualization</key><true/>
    </dict></plist>
  '';

  # Lima reads the image only when it creates the instance, so lima.yaml must
  # not depend on the guest's build: every guest change would rebuild a 3 GB
  # image. The bootstrap copies the first image here (docs/homelab/operator.md).
  image = "${home}/base-image.qcow2";

  limaYaml = (pkgs.formats.yaml { }).generate "lima.yaml" {
    vmType = "vz";
    arch = "aarch64";
    images = [
      {
        location = image;
        arch = "aarch64";
      }
    ];
    cpus = 4;
    # Counted as spent: the VZ footprint only grows, it never hands memory back.
    memory = "10GiB";
    disk = "80GiB";
    mounts = [
      {
        inherit (share) location mountPoint;
        writable = true;
      }
    ];
    mountType = "virtiofs";
    ssh = {
      localPort = 60022;
      loadDotSSHPubKeys = false;
    };
    containerd = {
      system = false;
      user = false;
    };
    vmOpts.vz.rosetta = {
      enabled = true;
      binfmt = true;
    };
    # Nothing is forwarded to the Mac: services are reached over the tailnet,
    # and SSH goes through ssh.localPort above. Lima otherwise forwards every
    # port the guest listens on.
    portForwards = [
      # nixos-lima #50: keep Lima's forwarder off the guest's DHCP client port.
      {
        guestPort = 68;
        proto = "udp";
        guestIP = "0.0.0.0";
        ignore = true;
      }
      {
        guestPortRange = [
          1
          65535
        ];
        proto = "any";
        guestIP = "0.0.0.0";
        ignore = true;
      }
    ];
  };
in
{
  users.knownUsers = [ "homelab" ];
  users.knownGroups = [ "homelab" ];
  # tomas is not a member: the limactl copy holds Full Disk Access, so anyone
  # who can run it can read every protected folder. Lima's state takes sudo.
  users.groups.homelab = {
    gid = 550;
    members = [ "homelab" ];
  };
  users.users.homelab = {
    uid = 550;
    gid = 550;
    inherit home;
    createHome = true;
    isHidden = true;
    shell = "/usr/bin/false";
  };

  environment.etc."homelab/lima.yaml".source = limaYaml;

  sops.secrets."limactl-signing/key" = { };

  # After sops-nix has installed the signing key (lib.mkAfter, 1500).
  system.activationScripts.postActivation.text = lib.mkOrder 1600 ''
    src=${lima}/bin/.limactl-wrapped
    # Lima finds its guest agents at <binary dir>/../share/lima.
    mkdir -p /usr/local/libexec/share
    ln -sfn ${lima}/share/lima /usr/local/libexec/share/lima
    if [ "$(cat ${stableLimactl}.src 2>/dev/null)" != "$src" ]; then
      echo "signing limactl into ${stableLimactl}" >&2
      mkdir -p "$(dirname ${stableLimactl})"
      tmp=$(mktemp -d)
      pass=$(/usr/bin/openssl rand -hex 16)
      ${pkgs.openssl}/bin/openssl pkcs12 -export -legacy -name homelab-codesign \
        -inkey ${config.sops.secrets."limactl-signing/key".path} -in ${signingCert} \
        -passout "pass:$pass" -out "$tmp/id.p12"
      /usr/bin/security create-keychain -p "$pass" "$tmp/sign.keychain-db"
      /usr/bin/security unlock-keychain -p "$pass" "$tmp/sign.keychain-db"
      /usr/bin/security import "$tmp/id.p12" -k "$tmp/sign.keychain-db" -P "$pass" -T /usr/bin/codesign >/dev/null
      /usr/bin/security set-key-partition-list -S apple-tool:,apple: -s -k "$pass" "$tmp/sign.keychain-db" >/dev/null
      cp "$src" ${stableLimactl}.new
      /usr/bin/codesign --force --sign ${signingIdentity} --keychain "$tmp/sign.keychain-db" \
        --identifier limactl --entitlements ${entitlements} ${stableLimactl}.new
      /usr/bin/security delete-keychain "$tmp/sign.keychain-db"
      rm -rf "$tmp"
      mv ${stableLimactl}.new ${stableLimactl}
      echo "$src" > ${stableLimactl}.src
      echo "limactl changed: restart the VM with homelab-reboot or" >&2
      echo "  sudo launchctl kickstart -k system/org.nixos.homelab-vm" >&2
    fi
    chown root:homelab ${stableLimactl}
    chmod 750 ${stableLimactl}
    # The app firewall queues inbound flows to an unlisted app for an Allow
    # prompt a daemon never gets; a self-signed cert isn't "signed" to it.
    /usr/libexec/ApplicationFirewall/socketfilterfw --add ${stableLimactl} >/dev/null
    /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp ${stableLimactl} >/dev/null

    # An instance folder with a lima.yaml is an instance to Lima, which
    # rereads it on every start, so config changes land on the next VM start.
    install -d -o homelab -g homelab -m 770 ${limaHome} ${limaHome}/${instance}
    ln -sfn /etc/homelab/lima.yaml ${limaHome}/${instance}/lima.yaml

    mkdir -p /var/log/homelab
    chown root:homelab /var/log/homelab
    chmod 750 /var/log/homelab
    touch /var/log/homelab/vm.log
    chown homelab:homelab /var/log/homelab/vm.log
    chmod 640 /var/log/homelab/vm.log
  '';

  launchd.daemons.homelab-vm = {
    # TCC charges the share access to the program launchd starts, so launchd
    # execs the granted limactl copy itself, not /bin/sh or a wrapper.
    # VZ refuses to start while the T7 share is missing; KeepAlive retries.
    serviceConfig = {
      ProgramArguments = [
        stableLimactl
        "start"
        "--tty=false"
        "--foreground"
        instance
      ];
      EnvironmentVariables = {
        LIMA_HOME = limaHome;
        HOME = home;
        PATH = "/usr/bin:/bin:/usr/sbin:/sbin";
      };
      Umask = 7;
      UserName = "homelab";
      GroupName = "homelab";
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Interactive";
      StandardOutPath = "/var/log/homelab/vm.log";
      StandardErrorPath = "/var/log/homelab/vm.log";
    };
  };
}
