{
  pkgs,
  lib,
  inputs,
  ...
}: {
  boot.loader.systemd-boot.configurationLimit = 5;

  time.timeZone = "America/New_York";

  networking.timeServers = [
    "0.us.pool.ntp.org"
    "1.us.pool.ntp.org"
    "2.us.pool.ntp.org"
    "3.us.pool.ntp.org"
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
      download-buffer-size = 268435456;
      http-connections = 25;
      connect-timeout = 5;
      max-jobs = "auto";
      cores = 0;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      min-free = 1 * 1024 * 1024 * 1024;
      max-free = 25 * 1024 * 1024 * 1024;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    neovim
    zsh
  ];

  # allows vscode remote-ssh to work
  programs.nix-ld.enable = true;

  system.stateVersion = "24.05";
}
