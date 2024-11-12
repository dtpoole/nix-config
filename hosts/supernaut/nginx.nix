_: {
  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "netdata.supernaut.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:19999";
          proxyWebsockets = true;
        };
        forceSSL = true;
        useACMEHost = "supernaut.poole.foo";
      };
    };
  };

  users.users.nginx.extraGroups = ["acme"];
}
