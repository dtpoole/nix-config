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


  systemd.services."linkding" = {
    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];
  };

  services.postgresql = {
    ensureDatabases = [ "linkding" ];
    ensureUsers = [{
      name = "linkding";
      ensurePermissions = { "DATABASE \"linkding\"" = "ALL PRIVILEGES"; };
    }];
  };

  age.secrets.crunch_linkding_password.file = "../../secrets/crunch_linkding_password.age ";

  virtualisation.oci-containers.containers = {
    "linkding" = {
      autoStart = true;
      image = "sissbruecker/linkding:latest";
      extraOptions = [ "--pull=always" ];
      environmentFiles = [ config.age.secrets.crunch_linkding_password.path ];
      environment = {
        "LD_DB_ENGINE" = "postgres";
        "LD_DB_DATABASE" = "linkding";
        "LD_DB_USER" = "linkding";
        "LD_DB_HOST" = "/run/postgresql/";
        "LD_SERVER_PORT" = "9090";
      };
      ports = [ "9091:9090" ];
      volumes = [
        "linkding:/etc/linkding/data"
        "/run/postgresql/:/run/postgresql/"
      ];
    };

  };

  services.nginx.virtualHosts."links2.poole.foo" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:9091";
      proxyWebsockets = true;
    };
    addSSL = true;
    useACMEHost = "links2.poole.foo";
  };


}
