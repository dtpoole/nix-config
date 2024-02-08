{ config, ... }:
{

  services.postgresql = {
    ensureDatabases = [ "firefly" ];
    ensureUsers = [{
      name = "firefly";
      ensureDBOwnership = true;
    }];
  };

  systemd.services."${config.virtualisation.oci-containers.backend}-firefly" = {
    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];
  };

  virtualisation.oci-containers.containers = {
    "firefly" = {
      autoStart = true;
      image = "fireflyiii/core:latest";
      extraOptions = [ "--pull=always" ];
      environment = {
        "TZ" = "America/New_York";
        "DB_CONNECTION" = "pgsql";
        "DB_DATABASE" = "firefly";
        "DB_USERNAME" = "firefly";
        "DB_HOST" = "/run/postgresql/";
      };
      ports = [ "8080:8080" ];
      volumes = [
        "firefly:/var/www/html/storage/upload"
        "/run/postgresql/:/run/postgresql/"
      ];
    };

  };


}
