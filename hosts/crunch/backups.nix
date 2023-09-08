{ config, host, ... }:
{

  age.secrets.restic_repository.file = ../../secrets/restic_repository.age;
  age.secrets.restic_repository_password.file = ../../secrets/restic_repository_password.age;

  services.restic.backups = {
    remotebackup = {
      extraOptions = [
        "--tag test-${host}"
      ];
      passwordFile = config.age.secrets.restic_repository_password.path;
      paths = [
        "/home"
      ];
      repository = config.age.secrets.restic_repository.path;
      timerConfig = {
        OnCalendar = "16:10";
        RandomizedDelaySec = "1m";
      };
    };
  };
}
