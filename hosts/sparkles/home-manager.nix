{...}: {
  imports = [
    ../../modules/home-manager
  ];

  packages.sets = {
    base = true;
    development = false;
    system = true;
    misc = false;
  };
}
