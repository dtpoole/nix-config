{
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
        DOMAIN = "gitea.x.poole.foo";
        SSH_DOMAIN = "git.poole.foo";
        ROOT_URL = "https://gitea.x.poole.foo/";
        DISABLE_ROUTER_LOG = true;
      };
      database.LOG_SQL = false;
    };
    dump.interval = "daily";
  };

}
