{ config, ... }:
{

  services.restic.backups = {
    cloud = {
      exclude = [
        "/var/cache"
        "/home/*/.cache"
        "/var/backup/restic"
        "/home/*/.vscode-server"
      ];
      passwordFile = config.age.secrets.restic_repository_password.path;
      paths = [
        "/home"
        "/var/lib"
        "/var/log"
        "/var/backup"
      ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 3"
      ];
      repositoryFile = config.age.secrets.restic_repository.path;
      environmentFile = config.age.secrets.restic_environment.path;
      timerConfig = {
        OnCalendar = "0/2:00";
        Persistent = true;
        RandomizedDelaySec = "15m";
      };
      initialize = true;
    };
  };
}
