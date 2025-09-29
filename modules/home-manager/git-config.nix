{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    git-config.enable = lib.mkEnableOption "enables git config";
  };

  config = lib.mkIf config.git-config.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitMinimal;
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
        ".stfolder"
        ".stignore"
        ".stversions/"
        "*.sync-conflict-*"
        "*~syncthing~*"
        ".syncthing.*"
        "*.tmp-syncthing-*"
      ];
    };
  };
}
