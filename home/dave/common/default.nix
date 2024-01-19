{ pkgs, lib, ... }:
let
  username = "dave";
  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  home.stateVersion = "23.11";

  home.username = "${username}";
  home.homeDirectory = lib.mkDefault "${homeDirectory}";

  imports = [
    ./zsh.nix
    ./fzf.nix
  ];

  programs.home-manager.enable = true;

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
    nix-direnv = { enable = true; };
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
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      StrictHostKeyChecking no
    '';
    matchBlocks = {
      "tank" = {
        hostname = "10.10.10.40";
        user = "tank";
      };
      "mini" = {
        hostname = "10.10.10.50";
      };
      "slug" = {
        hostname = "10.10.10.60";
      };
      "crunch" = {
        hostname = "10.10.10.150";
      };
      "supernaut" = {
        hostname = "10.10.10.120";
      };
      "jellyfin" = {
        hostname = "10.10.10.35";
        user = "root";
      };
      "plex" = {
        hostname = "10.10.10.36";
        user = "root";
      };
      "slurp" = {
        hostname = "10.10.10.37";
        user = "media";
      };
      "north" = {
        hostname = "north.poole.foo";
        port = 5829;
      };
    };
  };

  programs.tmux = {
    enable = true;
    historyLimit = 10000;
    plugins = with pkgs.tmuxPlugins; [
      nord
    ];
    extraConfig = ''
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

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    max-jobs = auto
  '';

  home.packages = with pkgs; [
    coreutils
    deadnix
    dig
    direnv
    dua
    duf
    du-dust
    fd
    figurine
    file
    gnumake
    hyperfine
    jq
    just
    keychain
    mosh
    neofetch
    nixpkgs-fmt
    nmap
    parallel
    pre-commit
    ripgrep
    shellcheck
    sqlite
    tree
    unzip
    vivid
  ];

}
