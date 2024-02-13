{ config, ... }:
{

  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://bitwarden.poole.fun";
      SIGNUPS_ALLOWED = false;
    };
  };

  services.nginx.virtualHosts."bitwarden.poole.fun" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
    };
  };

}
