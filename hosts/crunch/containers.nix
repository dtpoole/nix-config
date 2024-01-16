{ config, ... }:
{

  virtualisation.oci-containers.containers."it-tools" = {
    autoStart = true;
    image = "corentinth/it-tools:2023.12.21-5ed3693";
    extraOptions = [ "--pull=always" ];
    ports = [ "8070:80" ];
  };

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

  age.secrets.linkding_password.file = ../../secrets/crunch_linkding_password.age;

  virtualisation.oci-containers.containers = {
    "linkding" = {
      autoStart = true;
      image = "sissbruecker/linkding:1.23.1";
      extraOptions = [ "--pull=always" ];
      environmentFiles = [ config.age.secrets.linkding_password.path ];
      environment = {
        "LD_DB_ENGINE" = "postgres";
        "LD_DB_DATABASE" = "linkding";
        "LD_DB_USER" = "linkding";
        "LD_DB_HOST" = "/run/postgresql/";
        "LD_SERVER_PORT" = "9090";
      };
      ports = [ "9090:9090" ];
      volumes = [
        "linkding:/etc/linkding/data"
        "/run/postgresql/:/run/postgresql/"
      ];
    };

  };

}
