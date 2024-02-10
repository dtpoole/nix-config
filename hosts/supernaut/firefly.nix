{ config, pkgs, ... }:
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


  systemd.services.create-firefly-pod = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "${backend}-firefly.service" ];
    script = ''
      ${pkgs.podman}/bin/podman pod exists firefly || \
        ${pkgs.podman}/bin/podman pod create -n firefly
    '';
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      "firefly" = {
        autoStart = true;
        image = "fireflyiii/core:latest";
        extraOptions = [
          "--pull=always"
          "--pod=firefly"
        ];
        environment = {
          "TZ" = "America/New_York";
          "DB_CONNECTION" = "pgsql";
          "DB_DATABASE" = "firefly";
          "DB_USERNAME" = "firefly";
          "DB_HOST" = "/run/postgresql/";
          "APP_KEY" = "$(cat ${config.age.secrets.firefly_app_key.path})";
        };
        ports = [ "8080:8080" ];
        volumes = [
          "firefly:/var/www/html/storage/upload"
          "/run/postgresql/:/run/postgresql/"
        ];
      };
      "firefly-importer" = {
        autoStart = true;
        image = "fireflyiii/importer:latest";
        extraOptions = [
          "--pull=always"
          "--pod=firefly"
          "--requires=firefly"
        ];
        environment = {
          "TZ" = "America/New_York";
          "FIREFLY_III_ACCESS_TOKEN" = "";
          "VANITY_URL" = "";
        };
        ports = [ "8081:8080" ];
      };
    };
  };
}
