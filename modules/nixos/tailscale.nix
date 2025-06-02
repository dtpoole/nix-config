{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    tailscale = {
      enable = lib.mkEnableOption "enables tailscale";

      useAuthKey = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use an auth key file for automatic authentication";
      };
    };
  };

  config = lib.mkIf config.tailscale.enable {
    age.secrets.tailscale_auth_key = lib.mkIf config.tailscale.useAuthKey {
      file = ../../secrets/tailscale_auth_key.age;
    };

    services.tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
      authKeyFile = lib.mkIf config.tailscale.useAuthKey config.age.secrets.tailscale_auth_key.path;
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
