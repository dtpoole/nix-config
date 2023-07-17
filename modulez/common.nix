{
  
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  security.sudo.wheelNeedsPassword = false;
}