{ config, ... }:
{

  systemd.services."${config.virtualisation.oci-containers.backend}-linkding" = {
    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];
  };

  services.postgresql = {
    ensureDatabases = [ "linkding" ];
    ensureUsers = [{
      name = "linkding";
      ensureDBOwnership = true;
    }];
  };

  age.secrets.linkding_password.file = ../../secrets/linkding_password.age;

  virtualisation.oci-containers.containers = {
    "linkding" = {
      autoStart = true;
      image = "sissbruecker/linkding:1.30.0-plus";
      extraOptions = [ "--pull=always" ];
      environmentFiles = [ config.age.secrets.linkding_password.path ];
      environment = {
        "LD_DB_ENGINE" = "postgres";
        "LD_DB_DATABASE" = "linkding";
        "LD_DB_USER" = "linkding";
        "LD_DB_HOST" = "/run/postgresql/";
        "LD_SERVER_PORT" = "9090";
      };
      ports = [ "127.0.0.1:9090:9090" ];
      volumes = [
        "linkding:/etc/linkding/data"
        "/run/postgresql/:/run/postgresql/"
      ];
    };

  };

}
