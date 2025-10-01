{
  pkgs,
  lib,
  username,
  ...
}: {
  imports = [
    ./neovim.nix
    ./packages.nix
    ./programs.nix
    ./zsh.nix
    ./ghostty.nix
    ./git-config.nix
    ./ssh-config.nix
  ];

  home = {
    inherit username;
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
    stateVersion = "24.05";
  };

  # Set to false. home manager is available in the devShell
  programs.home-manager.enable = false;

  zsh.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  packages.enable = lib.mkDefault true;
  programs.enable = lib.mkDefault true;
}
