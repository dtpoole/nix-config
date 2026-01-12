{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    zsh.enable = lib.mkEnableOption "enables zsh";
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;

      dotDir = "${config.xdg.configHome}/zsh";

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = false;

      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
      ];

      envExtra = ''
        setopt no_global_rcs
        skip_global_compinit=1
      '';

      shellAliases = {
        ln = "ln -v";
        ls = "eza";
        l = "eza";
        la = "eza -la";
        ll = "eza -l";
        lt = "eza -snew -rl";
        tree = "eza --tree";
        grep = "grep --color=auto";
        cls = "clear";
        h = "history -E";
        more = "less";
        j = "jobs";
        df = "df -h";
        du = "du -h";
        dc = "docker compose";
        dtail = "docker logs -tf --tail='30'";
        ip = "ip --color=auto";
        destroy_ds = "find . -type f \\( -name .DS_Store -o -name \"._*\" \\) -delete";
      };

      history = {
        extended = true;
        expireDuplicatesFirst = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        path = "$ZDOTDIR/.zsh_history";
        save = 100000;
        size = 100000;
        share = true;
      };

      initContent = lib.mkMerge [
        # Set up LS_COLORS before completion init (order 550)
        (lib.mkOrder 550 ''
          if [[ -z "$LS_COLORS" ]]; then
              local vivid_cache="$ZDOTDIR/.vivid_cache"
              local vivid_bin="${pkgs.vivid}/bin/vivid"
              if [[ ! -f "$vivid_cache" ]] || [[ "$vivid_bin" -nt "$vivid_cache" ]]; then
                  "$vivid_bin" generate nord > "$vivid_cache"
              fi
              export LS_COLORS="$(cat "$vivid_cache")"
          fi
        '')

        # General configuration (order 1000)
        (lib.mkOrder 1000 ''
          bindkey '^ ' autosuggest-accept
          bindkey '^[[A' up-line-or-search
          bindkey '^[[B' down-line-or-search

          # Nix
          if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
              . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
          fi

          path+=($HOME/.local/bin $HOME/bin $HOME/.cargo/bin /usr/local/bin /usr/local/sbin /opt/homebrew/bin)
          typeset -U path

          tempe () {
            cd "$(mktemp -d)"
            chmod -R 0700 .
            if [[ $# -eq 1 ]]; then
              \mkdir -p "$1"
              cd "$1"
              chmod -R 0700 .
            fi
            pwd
          }

          ZSH_AUTOSUGGEST_MANUAL_REBIND=1
        '')
      ];

      completionInit = ''
        autoload -Uz compinit
        if [[ -n $ZDOTDIR/.zcompdump(#qN.mh+24) ]]; then
            compinit -u
            touch $ZDOTDIR/.zcompdump
        else
            compinit -C
        fi

        zstyle ':completion:*' menu select
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

        # Group completions by category
        zstyle ':completion:*' group-name '''
        zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
        zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
        zstyle ':completion:*:messages' format '%F{blue}-- %d --%f'

        # Case-insensitive, partial-word, and substring completion
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      '';

      loginExtra = ''
        if [[ -n "$SSH_CLIENT" ]]; then
            ${pkgs.figurine}/bin/figurine -f Rectangles.flf ''${HOST%%.*}
        fi
      '';
    };
  };
}
