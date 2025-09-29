{
  pkgs,
  lib,
  username,
  ...
}: {
  imports = [
    ./fzf.nix
    ./ghostty.nix
    ./neovim
    ./packages.nix
    ./programs.nix
    ./ssh-config.nix
    ./zsh.nix
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

  # xdg.configFile."nix/nix.conf".text = ''
  #   experimental-features = nix-command flakes
  #   max-jobs = auto
  #   warn-dirty = false
  # '';

  fzf.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  packages.enable = lib.mkDefault true;
  programs.enable = lib.mkDefault true;
  ssh-config.enable = lib.mkDefault false;
  ghostty.enable = lib.mkDefault false;
}
