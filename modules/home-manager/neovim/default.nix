{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    neovim.enable = lib.mkEnableOption "enables neovim";
  };

  config = lib.mkIf config.neovim.enable {
    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;
      withRuby = false;

      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
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
          plugin = nvim-tree-lua;
          type = "lua";
          config = ''
            -- disable netrw at the very start
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            require('nvim-tree').setup({
              view = {
                width = 35,
                side = "left",
              },
              renderer = {
                icons = {
                  show = {
                    git = true,
                    folder = true,
                    file = true,
                  },
                },
              },
              filters = {
                dotfiles = false,
                custom = { "^.git$" },
              },
              git = {
                enable = true,
                ignore = false,
              },
            })
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
            plugins:
              with plugins; [
                bash
                dockerfile
                json
                lua
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
              incremental_selection = {
                enable = true,
                keymaps = {
                  init_selection = "gnn",
                  node_incremental = "grn",
                  scope_incremental = "grc",
                  node_decremental = "grm",
                },
              },
            }
          '';
        }

        {
          plugin = telescope-nvim;
          type = "lua";
          config = ''
            require('telescope').setup({
              defaults = {
                -- Default configuration for telescope
                prompt_prefix = "🔍 ",
                selection_caret = "❯ ",
                path_display = { "truncate" },
                file_ignore_patterns = {
                  "node_modules",
                  ".git/",
                  "*.pyc",
                  "__pycache__",
                  ".direnv",
                  "result"
                },
                layout_strategy = 'horizontal',
                layout_config = {
                  horizontal = {
                    prompt_position = "top",
                    preview_width = 0.55,
                    results_width = 0.8,
                  },
                  vertical = {
                    mirror = false,
                  },
                  width = 0.87,
                  height = 0.80,
                  preview_cutoff = 120,
                },
                sorting_strategy = 'ascending',
                winblend = 0,
                border = {},
                borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
                color_devicons = true,
                use_less = true,
                set_env = { ['COLORTERM'] = 'truecolor' },
                file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
                grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
                qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

              },
              pickers = {
                find_files = {
                  theme = "dropdown",
                  previewer = false,
                  hidden = true,
                },
                buffers = {
                  theme = "dropdown",
                  previewer = false,
                  sort_lastused = true,
                },
                live_grep = {
                  theme = "dropdown",
                },
              },
            })

          '';
        }

        # plugin dependencies
        plenary-nvim
        nvim-web-devicons

        tcomment_vim
        vim-fugitive
        vim-surround
        vim-just
        vim-vinegar
      ];

      extraLuaConfig = builtins.readFile ./init.lua;
    };
  };
}
