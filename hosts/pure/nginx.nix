{
  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "ntfy.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:2586";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "ntfy.poole.foo";
      };

      "vault.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8222";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "vault.poole.foo";
      };
    };
  };

  users.users.nginx.extraGroups = ["acme"];
}
