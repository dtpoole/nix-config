{config, ...}: {
  age.secrets.eplustv_env.file = ../../secrets/eplustv_env.age;

  virtualisation.oci-containers.containers = {
    "eplustv" = {
      autoStart = true;
      image = "m0ngr31/eplustv";
      extraOptions = ["--pull=always"];
      environmentFiles = [config.age.secrets.eplustv_env.path];
      environment = {
        "PORT" = "8000";
        "ESPNPLUS" = "false";
        "NUM_OF_CHANNELS" = "30";
      };
      ports = ["8000:8000"];
      volumes = [
        "eplustv:/app/config"
      ];
    };
  };
}
