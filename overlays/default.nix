{inputs}: final: _prev: {
  unstable = inputs.nixpkgs-unstable.legacyPackages.${final.system};
}
