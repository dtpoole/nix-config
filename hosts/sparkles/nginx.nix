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
      "netdata.sparkles.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:19999";
          proxyWebsockets = true;
        };
        forceSSL = true;
        useACMEHost = "sparkles.poole.foo";
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

}
