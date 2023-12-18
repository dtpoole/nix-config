{
  services.tailscale = {
    enable = true;
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ]; # Tell the firewall to implicitly trust packets routed over Tailscale:
    checkReversePath = "loose";
  };

  networking.nameservers = [ "100.100.100.100" ];
}
