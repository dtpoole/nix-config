{
  pkgs,
  lib,
  config,
  name,
  email,
  ...
}: {
  options = {
    git-config.enable = lib.mkEnableOption "enables git config";
  };

  config = lib.mkIf config.git-config.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitMinimal;

      settings = {
        user = {
          inherit name email;
        };
        alias = {
          st = "status";
          co = "checkout";
          br = "branch";
          up = "rebase";
          ci = "commit";
        };
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

    programs.delta = {
      enable = true;
      options = {
        side-by-side = "true";
        theme = "Nord";
      };
    };
  };
}
