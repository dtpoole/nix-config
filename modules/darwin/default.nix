{
  pkgs,
  inputs,
  ...
}: let
  username = "dave";
in {
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;

  imports = [
    ./homebrew.nix
    ./mac.nix

    inputs.agenix.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = import ../home-manager/desktop.nix;
        extraSpecialArgs = {inherit username;};
      };
    }
  ];

  users.users.${username}.home = "/Users/${username}";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;

  # if you use zsh (the default on new macOS installations),
  # you'll need to enable this so nix-darwin creates a zshrc sourcing needed environment changes
  programs.zsh.enable = true;

  environment.shells = [pkgs.zsh];
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.default
    pkgs.nixd
  ];

  # for nixd
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
}
