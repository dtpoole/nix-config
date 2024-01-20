{

  # users.users.gitea = {
  #   useDefaultShell = true;
  #   home = "/var/lib/gitea";
  #   group = "gitea";
  #   isSystemUser = true;
  # };

  #user.extraGroups = [ "gitea" ];

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
        DOMAIN = "git.poole.foo";
        HTTP_ADDR = "127.0.0.1";
        ROOT_URL = "https://git.poole.foo/";
        DISABLE_ROUTER_LOG = true;
      };

      database.LOG_SQL = false;
      service.ENABLE_BASIC_AUTHENTICATION = false;
    };

    dump.interval = "daily";
  };

}
