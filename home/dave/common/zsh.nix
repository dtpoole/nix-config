{ pkgs, ... }: {

  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = ''
      setopt no_global_rcs
      skip_global_compinit=1
    '';

    shellAliases = {
      ln = "ln -v";
      ls = "ls --color=auto";
      l = "ls";
      la = "ls -lAh";
      ll = "ls -lh";
      lt = "ls -lt";
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
    };

    history = {
      extended = true;
      ignoreDups = true;
      path = "$ZDOTDIR/.zsh_history";
      save = 100000;
      share = true;
    };

    initExtraFirst = ''
      #zmodload zsh/zprof
    '';

    initExtra = ''
      bindkey '^ ' autosuggest-accept
      if [[ -z "$LS_COLORS" ]]; then
        export LS_COLORS="$(${pkgs.vivid}/bin/vivid generate nord)"
      fi

      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      path+=(/usr/local/bin /usr/local/sbin)

      fpath+=( $ZDOTDIR/functions )
      autoload -Uz ssh

      ZSH_AUTOSUGGEST_MANUAL_REBIND=1
    '';

    completionInit = ''
      autoload -Uz compinit
      if [[ -n $ZDOTDIR/.zcompdump(#qN.mh+24) ]]; then
        compinit -u
        touch $ZDOTDIR/.zcompdump
      else
        compinit -C
      fi

      zstyle ':completion:*' menu select
    '';

    loginExtra = ''
      if [[ -n "$SSH_CLIENT" ]]; then
        ${pkgs.figurine}/bin/figurine -f Rectangles.flf ''${HOST%%.*}
      fi
    '';

  };

  xdg.configFile."zsh/functions/ssh".text = ''
    # -- ssh/keychain (call keychain on first ssh call)
    ssh() {
      unfunction "$0"
      alias ssh="env TERM=xterm-256color ssh"
      eval "$(${pkgs.keychain}/bin/keychain -q --eval --quick --ignore-missing --agents ssh --inherit any id_rsa id_ed25519)"
      env TERM=xterm-256color $0 "$@"
    }
  '';

}
