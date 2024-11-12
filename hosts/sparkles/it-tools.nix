{
  virtualisation.oci-containers.containers."it-tools" = {
    autoStart = true;
    image = "ghcr.io/corentinth/it-tools:2024.10.22-7ca5933";
    extraOptions = ["--pull=always"];
    ports = ["127.0.0.1:8070:80"];
  };
}
