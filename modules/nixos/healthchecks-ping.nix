{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    healthchecks-ping.enable = lib.mkEnableOption "enables healthchecks ping";
  };

  config = lib.mkIf config.healthchecks-ping.enable {
    systemd.timers."healthchecks-ping" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "5m";
        Unit = "healthchecks-ping.service";
      };
    };

    systemd.services."healthchecks-ping" = {
      script = ''
        set -eu
        ${pkgs.runitor}/bin/runitor -uuid $(cat ${config.age.secrets.hc_ping.path}) -- echo hi.
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
