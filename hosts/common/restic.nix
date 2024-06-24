{ config, pkgs, ... }:
{

  services.restic.backups = {
    daily = {
      backupCleanupCommand = ''
        ${pkgs.runitor}/bin/runitor -no-start-ping -uuid $(cat ${config.age.secrets."restic/hc_uuid".path}) -- echo backup success.
      '';
      exclude = [
        "/var/cache"
        "/home/*/.cache"
        "/var/backup/restic"
        "/home/*/.vscode-server"
      ];
      paths = [
        "/home"
        "/var/lib"
        "/var/log"
        "/var/backup"
      ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 1"
      ];

      environmentFile = config.age.secrets."restic/env".path;
      passwordFile = config.age.secrets."restic/password".path;
      repositoryFile = config.age.secrets."restic/repo".path;

      timerConfig = {
        OnCalendar = "02:30";
        Persistent = true;
        RandomizedDelaySec = "10m";
      };
    };
  };
}
