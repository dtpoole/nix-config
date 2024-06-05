{

  virtualisation.oci-containers.containers."it-tools" = {
    autoStart = true;
    image = "corentinth/it-tools:latest";
    extraOptions = [ "--pull=always" ];
    ports = [ "8070:80" ];
  };

}