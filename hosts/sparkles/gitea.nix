{}: let
  host = "git.poole.foo";
in {
  services.postgresql = {
    ensureDatabases = [ "gitea" ];
    ensureUsers = [{
      name = "gitea";
      ensureDBOwnership = true;
    }];
  };

  services.gitea = {
    enable = true;
    lfs.enable = true;
    database = {
      user = "gitea";
      type = "postgres";
      socket = "/run/postgresql/";
    };

    settings = {
      server = {
        DOMAIN = "${host}";
        SSH_DOMAIN = "${host}";
        ROOT_URL = "https://${host}/";
        DISABLE_ROUTER_LOG = true;
      };
      database.LOG_SQL = false;
    };
    dump.interval = "daily";
  };

}
