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
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

}
