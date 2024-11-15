{
  config,
  pkgs,
  ...
}: {
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    settings = {
      server = {
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = config.age.secrets.searxng_secret.path;
      };
      ui = {
        default_theme = "simple";
      };
      search = {
        safe_search = 1;
        autocomplete = "duckduckgo";
      };
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."search.poole.foo" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8888";
        proxyWebsockets = true;
      };
    };
  };

  systemd.services.searx.serviceConfig = {
    DynamicUser = true;
    StateDirectory = "searxng";
  };
}
