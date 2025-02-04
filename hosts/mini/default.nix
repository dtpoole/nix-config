{
  pkgs,
  inputs,
  ...
}: let
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  username = "dave";
in {
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;

  imports = [
    inputs.agenix.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = import ../../modules/home-manager/desktop.nix;
        extraSpecialArgs = {inherit username;};
      };
    }
    ./homebrew.nix
    ./mac.nix
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

  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  #services.nix-daemon.package = pkgs.nixFlakes;

  # if you use zsh (the default on new macOS installations),
  # you'll need to enable this so nix-darwin creates a zshrc sourcing needed environment changes
  programs.zsh.enable = true;

  environment.shells = [pkgs.zsh];
  environment.systemPackages = [
    unstablePkgs.yt-dlp
    inputs.agenix.packages.${pkgs.system}.default
    pkgs.nixd
  ];

  # for nixd
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

}
