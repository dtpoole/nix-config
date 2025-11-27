let
  host = "git.poole.foo";
in {
  services.postgresql = {
    ensureDatabases = ["forgejo"];
    ensureUsers = [
      {
        name = "forgejo";
        ensureDBOwnership = true;
      }
    ];
  };

  services.forgejo = {
    enable = true;
    lfs.enable = true;
    database = {
      user = "forgejo";
      type = "postgres";
      socket = "/run/postgresql/";
    };

    settings = {
      server = {
        DOMAIN = "${host}";
        SSH_DOMAIN = "${host}";
        ROOT_URL = "https://${host}/";
        HTTP_PORT = 3000;
        DISABLE_ROUTER_LOG = true;
      };
      database.LOG_SQL = false;
    };
    dump.interval = "daily";
  };
}
