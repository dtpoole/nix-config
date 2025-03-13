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
    programs.bat = {
      enable = true;
      config = {
        italic-text = "always";
        tabs = "2";
        theme = "Nord";
      };
    };

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "nord";
        theme_background = false;
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
      };
    };

    programs.htop = {
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

    programs.git = {
      enable = true;
      userName = "David Poole";
      userEmail = "dtpoole@users.noreply.github.com";
      aliases = {
        st = "status";
        co = "checkout";
        br = "branch";
        up = "rebase";
        ci = "commit";
      };
      delta = {
        enable = true;
        options = {
          side-by-side = "true";
          theme = "Nord";
        };
      };
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = "true";
      };
      ignores = [
        "*~"
        ".DS_Store"
        ".vscode"
        "Thumbs.db"
      ];
    };

    programs.tmux = {
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

    programs.starship = {
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
      };
    };
  };
}
