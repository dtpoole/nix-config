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
      BAT_THEME=Nord # fix for delta

      fpath+=( $ZDOTDIR/functions )
      autoload -Uz ssh

      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      elif [ -e $HOME/.nix-profile/etc/profile.d/nix-daemon.sh ]; then
        . $HOME/.nix-profile/etc/profile.d/nix-daemon.sh
      fi

      path+=/usr/local/bin
    '';

    loginExtra = ''
      hostname -s | ${pkgs.figlet}/bin/figlet
    '';

    plugins = with pkgs; [
      {
        name = "agkozak-zsh-prompt";
        src = pkgs.fetchgit {
          url = "https://github.com/agkozak/agkozak-zsh-prompt";
          sha256 = "08f5q9z7mc2hshnx35nh4gqgdkvjv41704hn69vz0p190fkzx3i0";
        };
        file = "agkozak-zsh-prompt.plugin.zsh";
      }
    ];
  };

  xdg.configFile."zsh/functions/ssh".text = ''
    # -- ssh/keychain (call keychain on first ssh call)
    ssh() {
      unfunction "$0"
      eval "$(${pkgs.keychain}/bin/keychain -q --eval --quick --ignore-missing --agents ssh --inherit any id_rsa id_ed25519)"
      $0 "$@"
    }
  '';

}
