{
  virtualisation.oci-containers.containers."it-tools" = {
    autoStart = true;
    image = "ghcr.io/corentinth/it-tools:2024.10.22-7ca5933";
    extraOptions = [
      "--pull=always"
      "--memory=256m"
      "--memory-swap=512m" # 2x memory for swap
      "--cpus=0.5"
      "--pids-limit=50"
      "--read-only"
    ];
    ports = ["127.0.0.1:8070:80"];
  };
}
