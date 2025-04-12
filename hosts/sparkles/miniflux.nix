{config, ...}: {
  services.postgresql = {
    ensureDatabases = ["miniflux"];
    ensureUsers = [
      {
        name = "miniflux";
        ensureDBOwnership = true;
      }
    ];
  };

  age.secrets.miniflux_admin.file = ../../secrets/miniflux_admin.age;

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux_admin.path;
    createDatabaseLocally = false;
    config = {
      DATABASE_URL = "postgres://miniflux:@/miniflux?host=/run/postgresql";
      BASE_URL = "https://feeds.poole.foo";
      LISTEN_ADDR = "127.0.0.1:8080";
      POLLING_FREQUENCY = "15";
    };
  };

  systemd.services.miniflux.after = ["postgresql.service"];
}
