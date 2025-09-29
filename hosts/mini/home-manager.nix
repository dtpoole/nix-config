{...}: {
  imports = [
    ../../modules/home-manager
  ];

  ghostty.enable = true;
  ssh-config.enable = true;
  git-config.enable = true;
}
