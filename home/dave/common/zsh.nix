{ pkgs, ... }: {

  programs.zsh = {
    enable = true;
    autocd = true;

    completionInit = ''
      setopt extendedglob
      autoload -Uz compinit
      if [[ -n $ZDOTDIR/.zcompdump(#qN.mh+24) ]]; then
        compinit -u
        touch $ZDOTDIR/.zcompdump
      else
        compinit -C
      fi
    '';

    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;

    localVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

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

    envExtra = ''
      skip_global_compinit=1
    '';

    initExtra = ''
      bindkey '^ ' autosuggest-accept
      AGKOZAK_MULTILINE=0
      export LS_COLORS="$(${pkgs.vivid}/bin/vivid generate nord)"

      fpath+=( $ZDOTDIR/functions )
      autoload -Uz ssh

      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      elif [ -e $HOME/.nix-profile/etc/profile.d/nix-daemon.sh ]; then
        . $HOME/.nix-profile/etc/profile.d/nix-daemon.sh
      fi

      path+=(/usr/local/bin /usr/local/sbin)
    '';

    loginExtra = ''
      ${pkgs.figurine}/bin/figurine -v ''${HOST%%.*}
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
