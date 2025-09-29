{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    programs.enable = lib.mkEnableOption "enables programs";
  };

  config = lib.mkIf config.programs.enable {
    programs = {
      bat = {
        enable = true;
        config = {
          italic-text = "always";
          tabs = "2";
          theme = "Nord";
        };
      };

      btop = {
        enable = true;
        settings = {
          color_theme = "nord";
          theme_background = false;
        };
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        config = {
          hide_env_diff = true;
          DIRENV_WARN_TIMEOUT = 0;
        };
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
        changeDirWidgetCommand = "${pkgs.fd} --type d --hidden --follow --exclude .git";
        defaultCommand = "${pkgs.fd} --type f --hidden --follow --exclude .git";
        defaultOptions = ["--layout=reverse" "--info=inline" "--height=60%" "--multi"];

        colors = {
          fg = "#e5e9f0";
          bg = "#3b4252";
          hl = "#81a1c1";
          "fg+" = "#e5e9f0";
          "bg+" = "#3b4252";
          "hl+" = "#81a1c1";
          info = "#eacb8a";
          prompt = "#bf6069";
          pointer = "#b48dac";
          marker = "#a3be8b";
          spinner = "#b48dac";
          header = "#a3be8b";
        };
      };

      htop = {
        enable = true;
        settings = {
          hide_kernel_threads = true;
          hide_threads = true;
          hide_userland_threads = true;
          show_program_path = false;
          tree_view = false;
          vim_mode = true;
        };
      };

      tmux = {
        enable = true;
        historyLimit = 10000;
        plugins = with pkgs.tmuxPlugins; [
          nord
        ];
        extraConfig = ''
          setw -g mouse on
          set -g prefix C-a
          unbind C-b

          bind a send-prefix
          bind-key C-a last-window
          bind-key S command-prompt -p ssh: "new-window -n %1 'ssh %1'"
        '';
      };

      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          command_timeout = 1000;
          container = {
            disabled = true;
          };
          username = {
            style_user = "bold green";
            format = "[$user]($style)";
          };
          hostname = {
            ssh_symbol = "@";
            style = "bold green";
            format = "[$ssh_symbol$hostname]($style) ";
          };
          shlvl = {
            disabled = false;
            format = "$shlvl ▼ ";
            threshold = 4;
          };
          nix_shell = {
            symbol = "❄️";
            impure_msg = "";
            pure_msg = "pure";
          };
        };
      };

      zoxide = {
        enable = true;
        options = [
          "--cmd cd"
        ];
      };
    };
  };
}
