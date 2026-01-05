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

      serverAddress = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Address of the RustDesk ID/Rendezvous server (leave empty for public servers)";
      };
    };
  };

  config = lib.mkIf config.rustdesk.enable {
    environment.systemPackages = with pkgs; [
      rustdesk
    ];

    # Configure RustDesk for direct IP connections
    system.activationScripts.rustdeskConfig = lib.mkIf (config.rustdesk.serverAddress != "") ''
      mkdir -p /home/dave/.config/rustdesk
      cat > /home/dave/.config/rustdesk/RustDesk2.toml << EOF
      rendezvous_server = '${config.rustdesk.serverAddress}:21116'
      nat_type = 1
      serial = 0

      [options]
      custom-rendezvous-server = '${config.rustdesk.serverAddress}'
      relay-server = '${config.rustdesk.serverAddress}'
      api-server = '${config.rustdesk.serverAddress}'
      key = 'w0azzaRTrIJU08jghF5EJCLFF0HxgUlHQwt9BhTk3Pw='
      EOF
      chown -R dave:users /home/dave/.config/rustdesk
    '';

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

    # RustDesk user service (needs access to X session)
    systemd.user.services.rustdesk-service = {
      description = "RustDesk Service";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      environment = {
        DISPLAY = ":0";
        XAUTHORITY = "/home/dave/.Xauthority";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.rustdesk}/bin/rustdesk --service";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      preStart = ''
        # Ensure config directory exists
        mkdir -p ~/.config/rustdesk
      '';
    };

    # RustDesk GUI autostart (for local session access)
    environment.etc."xdg/autostart/rustdesk.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=RustDesk
      Comment=RustDesk Remote Desktop
      Exec=${pkgs.rustdesk}/bin/rustdesk
      Terminal=false
      X-GNOME-Autostart-enabled=true
      StartupNotify=false
    '';
  };
}
