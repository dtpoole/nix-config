{...}: {
  imports = [
    ../../modules/home-manager
  ];

  ssh-config.enable = true;

  packages.sets = {
    base = true;
    development = false;
    system = true;
    misc = false;
  };
}
