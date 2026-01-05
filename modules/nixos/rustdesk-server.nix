{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.rustdesk-server;
in {
  options = {
    rustdesk-server = {
      enable = lib.mkEnableOption "enables RustDesk server (hbbs and hbbr)";

      relayServer = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "IP address of the relay server (hbbr). Use 127.0.0.1 if running on same host.";
      };

      tailscaleOnly = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Restrict RustDesk server to Tailscale interface only";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Open firewall ports for RustDesk server";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rustdesk-server
    ];

    # hbbs - RustDesk ID/Rendezvous Server
    systemd.services.rustdesk-hbbs = {
      description = "RustDesk ID/Rendezvous Server (hbbs)";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.rustdesk-server}/bin/hbbs -r ${cfg.relayServer}";
        Restart = "on-failure";
        RestartSec = "5s";
        StateDirectory = "rustdesk-server";
        WorkingDirectory = "/var/lib/rustdesk-server";

        # Security hardening
        DynamicUser = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
      };
    };

    # hbbr - RustDesk Relay Server
    systemd.services.rustdesk-hbbr = {
      description = "RustDesk Relay Server (hbbr)";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.rustdesk-server}/bin/hbbr";
        Restart = "on-failure";
        RestartSec = "5s";
        StateDirectory = "rustdesk-server";
        WorkingDirectory = "/var/lib/rustdesk-server";

        # Security hardening
        DynamicUser = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
      };
    };

    # Firewall configuration
    networking.firewall = lib.mkIf cfg.openFirewall (
      if cfg.tailscaleOnly
      then {
        # Restrict to Tailscale interface only
        interfaces.tailscale0 = {
          # hbbs ports: TCP 21115, 21116, 21118; UDP 21116
          # hbbr ports: TCP 21117, 21119
          allowedTCPPorts = [21115 21116 21117 21118 21119];
          allowedUDPPorts = [21116];
        };
      }
      else {
        # Open ports on all interfaces
        # hbbs ports: TCP 21115, 21116, 21118; UDP 21116
        # hbbr ports: TCP 21117, 21119
        allowedTCPPorts = [21115 21116 21117 21118 21119];
        allowedUDPPorts = [21116];
      }
    );

    system.activationScripts.rustdesk-server-info = lib.mkAfter ''
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "RustDesk Server is enabled"
      echo "ID Server (hbbs) ports: TCP 21115, 21116, 21118; UDP 21116"
      echo "Relay Server (hbbr) ports: TCP 21117, 21119"
      ${
        if cfg.tailscaleOnly
        then ''
          echo "Firewall: Restricted to Tailscale interface only"
        ''
        else ''
          echo "Firewall: Ports open on all interfaces"
        ''
      }
      echo "Key location: /var/lib/rustdesk-server/id_ed25519.pub"
      echo "View public key with: sudo cat /var/lib/rustdesk-server/id_ed25519.pub"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';
  };
}
