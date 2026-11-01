# sops-nix: the guest decrypts its own file in nix-secrets with its SSH host
# key, kept on the VM disk (and in the restic backup, so a rebuilt guest needs
# no re-keying). No plaintext crosses the T7 share.
{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${inputs.secrets}/homelab.yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
