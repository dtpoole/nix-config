{ config, pkgs, username, ... }:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  home.username = username;
  home.homeDirectory =
    if isDarwin
    then "/Users/${username}"
    else "/home/${username}";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  imports = [
    ./zsh.nix
    ./fzf.nix
    ./programs.nix
    ./neovim
    ./tmux
    ./kitty.nix
    ./bat.nix
    ./git.nix
    ./htop.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    max-jobs = auto
  '';
}
