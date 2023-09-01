{ unstablePkgs, ... }:

{
  services.tailscale.enable = true;
  services.tailscale.package = unstablePkgs.tailscale;

  # Tell the firewall to implicitly trust packets routed over Tailscale:
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
