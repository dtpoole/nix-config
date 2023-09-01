{ config, pkgs, ... }:
{

  systemd.timers."healthchecks.io-ping" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "healthchecks.io-ping.service";
    };
  };

  systemd.services."healthchecks.io-ping" = {
    script = ''
      set -eu
      ${pkgs.runitor}/bin/runitor -uuid ${config.age.secrets.hc_ping.path} -- echo hi.
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

}


