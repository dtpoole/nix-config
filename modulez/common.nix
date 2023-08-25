{ host, ... }:

{

  networking.hostName = "${host}"; # Define your hostname.

  boot.loader.systemd-boot.configurationLimit = 5;

  time.timeZone = "America/New_York";

  networking.timeServers = [
    "0.us.pool.ntp.org"
    "1.us.pool.ntp.org"
    "2.us.pool.ntp.org"
    "3.us.pool.ntp.org"
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    settings = {
      auto-optimise-store = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;

}
