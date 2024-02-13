{ config, ... }:
{

  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://bitwarden.poole.fun";
      SIGNUPS_ALLOWED = true;
      ROCKET_PORT = 8222;
      ADMIN_TOKEN = "$(cat ${config.age.secrets.vaultwarden_admin_token.path})";
    };
  };

  services.nginx.virtualHosts."bitwarden.poole.fun" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      proxyWebsockets = true;
    };
  };

}
