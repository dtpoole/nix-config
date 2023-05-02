{ config, lib, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withRuby = false;

    #defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      ale
      nord-nvim
      vim-surround
      vim-grepper
      polyglot
      fzf-vim
      tcomment_vim
      vim-fugitive
    ];

    extraConfig = builtins.readFile ./init.vim;
    #extraLuaConfig = builtins.readFile ./init.lua;
  };
}
