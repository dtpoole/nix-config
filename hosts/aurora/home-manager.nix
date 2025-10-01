{...}: {
  imports = [
    ../../modules/home-manager
  ];

  neovim = {
    enable = true;
    profile = "full";
  };

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
