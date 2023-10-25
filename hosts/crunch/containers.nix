{

  virtualisation.oci-containers.containers."it-tools" = {
    autoStart = true;
    image = "corentinth/it-tools:latest";
    extraOptions = [ "--pull=always" ];
    ports = [ "8070:80" ];
  };

  services.nginx.virtualHosts."tools.poole.foo" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8070}";
      proxyWebsockets = true;
    };
    addSSL = true;
    useACMEHost = "tools.poole.foo";
  };

}
