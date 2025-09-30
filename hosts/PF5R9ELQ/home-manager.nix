{...}: {
  imports = [
    ../../modules/home-manager
  ];

  packages.sets = {
    base = true;
    development = true;
    system = true;
    misc = false;
  };
}
