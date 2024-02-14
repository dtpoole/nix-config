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
        DOMAIN = "git.poole.foo";
        HTTP_ADDR = "127.0.0.1";
        ROOT_URL = "https://git.poole.foo/";
        DISABLE_ROUTER_LOG = true;
      };
      database.LOG_SQL = false;
    };
    dump.interval = "daily";
  };

  services.nginx = {
    clientMaxBodySize = "512M"; # Gitea recommended
    virtualHosts = {
      "git.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
        forceSSL = true;
        useACMEHost = "git.poole.foo";
      };
    };
  };
}
