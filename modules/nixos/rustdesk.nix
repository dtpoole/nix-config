{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    rustdesk = {
      enable = lib.mkEnableOption "enables RustDesk remote desktop";

      tailscaleOnly = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Restrict RustDesk to Tailscale interface only";
      };
    };
  };

  config = lib.mkIf config.rustdesk.enable {
    environment.systemPackages = with pkgs; [
      rustdesk
    ];

    # RustDesk requires these ports:
    # TCP: 21115-21119 (signal, relay, web client)
    # UDP: 21116 (ID registration, heartbeat, NAT traversal)

    networking.firewall = lib.mkIf config.rustdesk.tailscaleOnly {
      # Allow RustDesk ports on Tailscale interface only
      interfaces.tailscale0 = {
        allowedTCPPorts = [21115 21116 21117 21118 21119];
        allowedUDPPorts = [21116];
      };
    };

    # Systemd user service for RustDesk daemon
    systemd.user.services.rustdesk = {
      description = "RustDesk Remote Desktop";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${pkgs.rustdesk}/bin/rustdesk --service";
        Restart = "on-failure";
      };
    };
  };
}
