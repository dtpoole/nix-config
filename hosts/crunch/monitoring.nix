{ config, pkgs, ... }: {

  services.prometheus = {
    port = 3020;
    enable = true;

    exporters = {
      node = {
        port = 3021;
        enabledCollectors = [ "systemd" ];
        enable = true;
      };
    };

    # ingest the published nodes
    scrapeConfigs = [{
      job_name = "nodes";
      static_configs = [{
        targets = [
          "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
        ];
      }];
    }];
  };

  services.grafana = {
    enable = true;

    settings = {
      server = {
        domain = "grafana.crunch.poole.foo";
        http_addr = "127.0.0.1";
        http_port = 2342;
      };
      analytics.reporting_enabled = false;
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }
        # {
        #   name = "Loki";
        #   type = "loki";
        #   access = "proxy";
        #   url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        # }
      ];
    };
  };

  services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
    };
    addSSL = true;
    useACMEHost = "crunch.poole.foo";
  };

}
