{ pkgs, ... }: {
  
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withRuby = false;

    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      {
        plugin = ale;
        type = "lua";
        config = ''
          -- Ale
          vim.g.ale_fix_on_save = 1
          vim.g.ale_lint_on_text_changed = 'normal'
          vim.g.ale_lint_on_insert_leave = 1
          vim.g.ale_lint_delay = 0
          vim.g.ale_set_quickfix = 0
          vim.g.ale_set_loclist = 0
        '';
      }

      {
        plugin = nord-nvim;
        type = "lua";
        config = ''
          
          -- nord
          vim.g.nord_contrast = false
          vim.g.nord_borders = true
          vim.g.nord_disable_background = false
          vim.g.nord_italic = true
          vim.g.nord_italic_comments = true
          vim.g.nord_bold = false

          require('nord').set()
        '';
      }
      
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup {
            options = {
              theme = 'nord'
            }
          }
        '';
      }

      {
        plugin = nvim-treesitter.withPlugins (
          plugins: with plugins; [
            bash
            dockerfile
            json
            make
            markdown
            nix
            python
            sql
            terraform
            toml
            vim
            yaml
          ]
        );
        type = "lua";
        config = ''
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true,
              disable = {},
            },
            indent = {
              enable = true,
              disable = {},
            },
          }
        '';
      }

      polyglot
      fzf-vim
      tcomment_vim
      vim-fugitive
      vim-surround

    ];

    extraLuaConfig = builtins.readFile ./init.lua;

  };
}
