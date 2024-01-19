{ pkgs, inputs, ... }:

let
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  services.tailscale = {
    enable = true;
    package = unstablePkgs.tailscale;
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ]; # Tell the firewall to implicitly trust packets routed over Tailscale
    checkReversePath = "loose";
  };

  networking.nameservers = [ "100.100.100.100" ];
}
