{...}: {
  imports = [
    ../../modules/home-manager
  ];

  ghostty.enable = true;
  ssh-config.enable = true;
  git-config.enable = true;

  packages.sets = {
    base = true;
    development = true;
    system = true;
    misc = false;
  };
}
