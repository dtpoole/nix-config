{
  lib,
  config,
  ...
}: {
  options = {
    vaultwarden = {
      enable = lib.mkEnableOption "enables vaultwarden";

      domain = lib.mkOption {
        type = lib.types.str;
        example = "vault.example.com";
        description = "Domain name for vaultwarden";
      };
    };
  };

  config = lib.mkIf config.vaultwarden.enable {
    age.secrets.vaultwarden_admin_token.file = ../../secrets/vaultwarden_admin_token.age;

    services.vaultwarden = {
      enable = true;
      environmentFile = config.age.secrets.vaultwarden_admin_token.path;
      config = {
        DOMAIN = "https://${config.vaultwarden.domain}";
        SIGNUPS_ALLOWED = true;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
      };
      backupDir = "/var/backup/vaultwarden";
    };
  };
}
