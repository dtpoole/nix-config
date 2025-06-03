{inputs}: final: prev: let
  unstablePkgs = [
    "tailscale"
    "yt-dlp"
    "beszel"
  ];
in {
  unstable = prev.lib.genAttrs unstablePkgs (
    name:
      inputs.nixpkgs-unstable.legacyPackages.${final.system}.${name}
  );
}
