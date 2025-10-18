{config, ...}: {
  age.secrets.mlbserver_env.file = ../../secrets/mlbserver_env.age;

  virtualisation.podman.autoPrune = {
    enable = true;
    dates = "daily";
    flags = [
      "--all"
    ];
  };

  virtualisation.oci-containers.containers = {
    "mlbserver" = {
      autoStart = true;
      image = "tonywagner/mlbserver";
      extraOptions = [
        "--pull=always"
        "--memory=1g"
        "--memory-swap=2g"
        "--cpus=2.0"
        "--pids-limit=200"
      ];
      environmentFiles = [config.age.secrets.mlbserver_env.path];
      ports = ["100.91.24.97:9999:9999"];
      volumes = [
        "mlbserver:/mlbserver/data_directory"
      ];
    };
  };
}
