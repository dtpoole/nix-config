{config, ...}: {

  age.secrets.mlbserver_env.file = ../../secrets/mlbserver_env.age;

  virtualisation.podman.autoPrune = {
    enable = true;
    flags = [
      "--all"
    ];
  };

  virtualisation.oci-containers.containers = {
    "eplustv" = {
      autoStart = true;
      image = "m0ngr31/eplustv";
      extraOptions = ["--pull=always"];
      environment = {
        "PORT" = "8000";
      };
      ports = ["100.91.24.97:8000:8000"];
      volumes = [
        "eplustv:/app/config"
      ];
    };

    "mlbserver" = {
      autoStart = true;
      image = "tonywagner/mlbserver";
      extraOptions = ["--pull=always"];
      environmentFiles = [config.age.secrets.mlbserver_env.path];
      ports = ["100.91.24.97:9999:9999"];
      volumes = [
        "mlbserver:/mlbserver/data_directory"
      ];
    };
  };
}
