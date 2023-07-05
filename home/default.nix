{ pkgs, username, ... }:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  home.username = username;
  home.homeDirectory =
    if isDarwin
    then "/Users/${username}"
    else "/home/${username}";

  home.stateVersion = "23.05";

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
    ./btop.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    max-jobs = auto
  '';
}
