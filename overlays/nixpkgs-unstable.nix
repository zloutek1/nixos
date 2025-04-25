{ inputs, ... }:

(final: prev: {
  unstable = inputs.nixpkgs-unstable {
    system = final.system;
  };
})