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
    config = {
      DATABASE_URL = "postgres://miniflux:@/miniflux?host=/run/postgresql";
    };
  };

  systemd.services.miniflux.after = ["postgresql.service"];
}
