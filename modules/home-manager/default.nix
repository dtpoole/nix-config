{
  pkgs,
  lib,
  username,
  ...
}: {
  imports = [
    ./fzf.nix
    ./kitty.nix
    ./neovim
    ./packages.nix
    ./programs.nix
    ./ssh-config.nix
    ./zsh.nix
  ];

  home = {
    username = username;
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    max-jobs = auto
    warn-dirty = false
  '';

  fzf.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  packages.enable = lib.mkDefault true;
  programs.enable = lib.mkDefault true;
  ssh-config.enable = lib.mkDefault true;
}
