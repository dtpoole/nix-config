{ config, ... }:
{
  age.secrets.restic_repository.file = ../../secrets/restic_repository.age;
  age.secrets.restic_repository_password.file = ../../secrets/restic_repository_password.age;

  services.restic.backups = {
    remotebackup = {
      backupCleanupCommand = '''
        ${pkgs.runitor}/bin/runitor -uuid $(cat ${config.age.secrets.hc_backup.path}) -- echo backup success.
      '';
      exclude = [
        "/var/cache"
        "/home/*/.cache"
      ];
      passwordFile = config.age.secrets.restic_repository_password.path;
      paths = [
        "/home"
        "/var/log"
      ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 3"
      ];
      repositoryFile = config.age.secrets.restic_repository.path;
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
        RandomizedDelaySec = "5m";
      };
    };
  };
}
