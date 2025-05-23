{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    tailscale.enable = lib.mkEnableOption "enables tailscale";
  };

  config = lib.mkIf config.tailscale.enable {
    age.secrets.tailscale_auth_key.file = ../../secrets/tailscale_auth_key.age;

    services.tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
      authKeyFile = config.age.secrets.tailscale_auth_key.path;
      useRoutingFeatures = "client";
    };

    networking = {
      firewall = {
        trustedInterfaces = ["tailscale0"]; # Tell the firewall to implicitly trust packets routed over Tailscale
        checkReversePath = "loose";
      };
      nameservers = ["100.100.100.100"];
    };
  };
}
