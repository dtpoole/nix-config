{ config, pkgs, ... }: {

  services.grafana = {
    enable = true;
    domain = "grafana.crunch.poole.foo";
    port = 2342;
    addr = "127.0.0.1";
  };

  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
    addSSL = true;
    useACMEHost = ${config.services.grafana.domain};
  };
}
