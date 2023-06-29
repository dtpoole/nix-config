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

      {
        plugin = nvim-treesitter.withPlugins (p: [ 
          p.bash p.dockerfile
          p.git_config p.git_rebase p.gitattributes p.gitcommit p.gitignore 
          p.markdown p.sql p.yaml p.json p.make p.nix p.python p.terraform p.vim
        ]);
        
        type = "lua";
        config = ''
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true,
              disable = {},
            },
            indent = {
              enable = false,
              disable = {},
            },
          }
        '';
      }

    ];

    extraConfig = builtins.readFile ./init.vim;
    #extraLuaConfig = builtins.readFile ./init.lua;
  };
}
