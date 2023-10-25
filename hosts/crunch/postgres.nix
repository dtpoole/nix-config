{ pkgs, ... }:

{

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    authentication = lib.mkOverride ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
    '';
    settings = {
      password_encryption = "scram-sha-256";
    };
  };

  services.postgresqlBackup = {
    enable = true;
    location = "/var/backup/postgresql";
    backupAll = true;
  };

}
