# * Haskell package set
#
# A package set with (./default.nix).overlays.haskellPackages applied.

{ compiler ? "ghc864" }:

# Get the set of overlays from ./default.nix
let nur = pkgs: import ./default.nix { inherit pkgs; };

in import ./nixpkgs.nix { } {
  config = {
    allowUnfree = true; # https://github.com/GaloisInc/flexdis86/pull/1 # TODO: still necessary?
    allowBroken = true; # GHC 8.8.1, bytestring-handle
  };
  overlays = builtins.trace "here" [
    (self: super: { abc = (nur super).abc; })
    (self: super: {
      haskellPackages = (nur super).overlays.haskellPackages self super;
    })
  ];
}