{...}: {
  imports = [
    ../../modules/home-manager
  ];

  neovim.enable = true;
  ssh-config.enable = true;

  packages.sets = {
    base = true;
    development = false;
    system = true;
    misc = false;
  };
}
