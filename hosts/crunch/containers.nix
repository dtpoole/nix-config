{ config, ... }:
{


  virtualisation.oci-containers.containers."it-tools" = {
    autoStart = true;
    image = "corentinth/it-tools:latest";
    extraOptions = [ "--pull=always" ];
    ports = [ "8070:80" ];
  };

  services.nginx.virtualHosts."tools.poole.foo" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8070";
      proxyWebsockets = true;
    };
    addSSL = true;
    useACMEHost = "tools.poole.foo";
  };


  systemd.services."${config.virtualisation.oci-containers.backend}-linkding" = {
    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];
  };

  services.postgresql = {
    ensureDatabases = [ "linkding" ];
    ensureUsers = [{
      name = "linkding";
      ensurePermissions = {
        "DATABASE linkding" = "ALL";
        "SCHEMA public" = "ALL";
        "ALL TABLES IN SCHEMA public" = "ALL";
      };
    }];
  };

  age.secrets.linkding_password.file = ../../secrets/crunch_linkding_password.age;

  virtualisation.oci-containers.containers = {
    "linkding" = {
      autoStart = true;
      image = "sissbruecker/linkding:1.22.3";
      # extraOptions = [ "--pull=always" ];
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

  services.nginx.virtualHosts."links.poole.foo" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:9090";
      proxyWebsockets = true;
    };
    addSSL = true;
    useACMEHost = "links.poole.foo";
  };


}
