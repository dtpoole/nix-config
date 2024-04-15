{ pkgs, ... }:

{

  imports = [
    ./sshd.nix
    ./user.nix
  ];

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
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    gnumake
    vim
    zsh
  ];

  # allows vscode remote-ssh to work
  programs.nix-ld.enable = true;

  services.journald.extraConfig = "SystemMaxUse=100M";

  system.stateVersion = "23.11";

}
