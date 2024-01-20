{

  users.users.git = {
    useDefaultShell = true;
    home = "/var/lib/gitea";
    group = "gitea";
    isSystemUser = true;
  };

  user.extraGroups = [ "gitea" ];

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

    # We're assuming SSL-only connectivity
    # cookieSecure = true;
    # Only log what's important, but Info is necessary for fail2ban to work
    log.level = "Info";
    settings = {
      server.DISABLE_ROUTER_LOG = true;
      database.LOG_SQL = false;
      service.ENABLE_BASIC_AUTHENTICATION = false;
    };

    dump.interval = "daily";
  };

}
