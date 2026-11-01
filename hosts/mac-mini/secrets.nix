# sops-nix: the Mac decrypts its own file in the private nix-secrets repo with
# its SSH host key. The same key is a read-only deploy key on nix-secrets, so
# root can fetch the input for `sudo darwin-rebuild switch`. A macOS reinstall
# means a new host key: `sops updatekeys` and replace the deploy key.
{ inputs, pkgs, ... }:
let
  hostKey = "/etc/ssh/ssh_host_ed25519_key";
in
{
  imports = [ inputs.sops-nix.darwinModules.sops ];

  sops = {
    defaultSopsFile = "${inputs.secrets}/mac-mini.yaml";
    age.sshKeyPaths = [ hostKey ];
  };

  programs.ssh.knownHosts."github.com".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  # tomas fetches with the tomas@mac-mini key (also a deploy key, for rebuild-homelab).
  environment.etc."ssh/ssh_config.d/100-github-root.conf".text = ''
    Match host github.com localuser root
      IdentityFile ${hostKey}
  '';

  environment.systemPackages = [
    pkgs.sops
    pkgs.ssh-to-age
  ];
}
