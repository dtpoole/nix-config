{
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./autoupgrade.nix
    ./beszel.nix
    ./desktop.nix
    ./dns.nix
    ./healthchecks-ping.nix
    ./netdata.nix
    ./postgres.nix
    ./restic.nix
    ./sshd.nix
    ./tailscale.nix
    ./users.nix
    ./zram.nix

    inputs.agenix.nixosModules.default
  ];

  sshd.enable = lib.mkDefault true;
  users.enable = lib.mkDefault true;

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

  services.journald = {
    extraConfig = ''
      SystemMaxUse=100M
      RuntimeMaxUse=50M
      MaxFileSec=7day
      RateLimitInterval=30s
      RateLimitBurst=1000
      Storage=persistent
      Compress=yes
      ForwardToSyslog=no
    '';
  };

  systemd.coredump = {
    enable = true;
    extraConfig = "Storage=none";
  };

  system.stateVersion = "24.05";
}
