{

  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "netdata.sparkles.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:19999";
          proxyWebsockets = true;
        };
        forceSSL = true;
        useACMEHost = "sparkles.poole.foo";
      };
      "git.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "git.poole.foo";
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
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

}
