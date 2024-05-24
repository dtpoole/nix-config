{ config, ... }:
{

  age.secrets.restic_repository_password.file = ../../secrets/restic_repository_password.age;

  services.restic.backups = {
    local = {
      exclude = [
        "/var/cache"
        "/home/*/.cache"
        "/var/backup/restic"
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
      repository = "/var/backup/restic";
        timerConfig = {
        OnCalendar = "0/6:00";
        Persistent = true;
        RandomizedDelaySec = "15m";
      };
    };
  };
}
