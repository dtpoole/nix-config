{ config, pkgs, inputs, ... }:

let
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{

  age.secrets.tailscale_auth_key.file = ../../secrets/tailscale_auth_key.age;

  services.tailscale = {
    enable = true;
    package = unstablePkgs.tailscale;
    authKeyFile = config.age.secrets.tailscale_auth_key.path;
  };

  networking = {
    firewall = {
      trustedInterfaces = [ "tailscale0" ]; # Tell the firewall to implicitly trust packets routed over Tailscale
      checkReversePath = "loose";
    };
    nameservers = [ "100.100.100.100" ];
  };

}
