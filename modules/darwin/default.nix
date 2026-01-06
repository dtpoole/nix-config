{
  pkgs,
  inputs,
  username,
  ...
}: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;

  imports = [
    ./homebrew.nix
    ./mac.nix
  ];

  users.users.${username}.home = "/Users/${username}";

  system.primaryUser = "${username}";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    gc = {
      automatic = true;
      interval = [
        {
          Hour = 14;
          Minute = 15;
          Weekday = 4;
        }
      ];
      options = "--delete-older-than 1w";
    };
    optimise.automatic = true;
    settings = {
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

  # if you use zsh (the default on new macOS installations),
  # you'll need to enable this so nix-darwin creates a zshrc sourcing needed environment changes
  programs.zsh.enable = true;

  environment.shells = [pkgs.zsh];
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.default
    pkgs.nixd
  ];

  # Suppress Homebrew auto-update hints
  environment.variables = {
    HOMEBREW_NO_ENV_HINTS = "1";
  };

  # for nixd
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
}
