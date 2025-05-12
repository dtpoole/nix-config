{}: {

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
  };
}
