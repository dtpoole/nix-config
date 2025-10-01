{...}: {
  imports = [
    ../../modules/home-manager
  ];

  neovim = {
    enable = true;
    profile = "full";
  };

  packages.sets = {
    base = true;
    development = true;
    system = true;
    misc = false;
  };
}
