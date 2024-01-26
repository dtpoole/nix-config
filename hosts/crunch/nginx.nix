{

  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "links.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:9090";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "links.poole.foo";
      };
      "tools.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8070";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "tools.poole.foo";
      };
      "netdata.crunch.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:19999";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "crunch.poole.foo";
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

}
