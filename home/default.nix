{ pkgs, username, ... }:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  home.stateVersion = "23.05";

  home.username = username;
  home.homeDirectory =
    if isDarwin
    then "/Users/${username}"
    else "/home/${username}";

  imports = [
    ./zsh.nix
    ./fzf.nix
    ./neovim
    ./kitty.nix
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
      theme_background = true;
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
      "slippy" = {
        hostname = "10.10.10.10";
      };
      "chacha" = {
        hostname = "10.10.10.11";
      };
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

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    max-jobs = auto
  '';

  home.packages = with pkgs; [
    coreutils
    dig
    direnv
    dua
    duf
    du-dust
    fd
    figlet
    file
    gnumake
    jq
    keychain
    mosh
    nixpkgs-fmt
    nmap
    parallel
    ripgrep
    shellcheck
    sqlite
    tmux
    tree
    vivid
  ];

  #xdg.configFile."age_test.txt".text = config.age.secrets.test.path;

}
