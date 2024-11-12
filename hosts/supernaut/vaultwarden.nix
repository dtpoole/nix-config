{config, ...}: {
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vault.poole.fun";
      SIGNUPS_ALLOWED = true;
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
      ADMIN_TOKEN = "$(cat ${config.age.secrets.vaultwarden_admin_token.path})";
    };
    backupDir = "/var/backup/vaultwarden";
  };
}
