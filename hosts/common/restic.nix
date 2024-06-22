{ config, pkgs, ... }:
{

  services.restic.backups = {
    backup = {
      backupCleanupCommand = ''
        ${pkgs.runitor}/bin/runitor -uuid $(cat ${config.age.secrets.restic_hc_uuid.path}) -- echo backup success.
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

      environmentFile = config.age.secrets.restic_environment.path;
      passwordFile = config.age.secrets.restic_password.path;
      repositoryFile = config.age.secrets.restic_repository.path;

      timerConfig = {
        OnCalendar = "0/4:00";
        Persistent = true;
        RandomizedDelaySec = "15m";
      };
    };
  };
}
