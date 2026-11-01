Stand-ins for the private `nix-secrets` repo, so CI and a checkout without
access can evaluate and build every host:

    nix flake check --override-input secrets path:./tests/secrets

Same file names and keys as the real repo; every value is `stub`, encrypted to
a throwaway age key nobody kept.
