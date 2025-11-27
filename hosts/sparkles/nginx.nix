{
  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "git.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "git.poole.foo";
      };
      "git2.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "git2.poole.foo";
      };
      "tools.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8070";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "tools.poole.foo";
      };
      "links.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:9090";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "links.poole.foo";
      };
      "feeds.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "feeds.poole.foo";
      };
    };
  };

  users.users.nginx.extraGroups = ["acme"];
}
