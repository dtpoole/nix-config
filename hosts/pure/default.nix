{lib, ...}: {
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/server.nix
    ../../modules/nixos/profiles/desktop.nix
    ../../modules/nixos/remote-builder.nix
    ../../modules/nixos/rustdesk.nix
    ../../modules/nixos/ntfy.nix
    ./acme.nix
    ./vaultwarden.nix
    ./nginx.nix
  ];

  # Enable desktop profile
  profiles.desktop.enable = true;

  # Enable RustDesk client
  rustdesk = {
    enable = true;
    tailscaleOnly = false;
    serverAddress = "10.10.2.45";
  };

  # Enable RustDesk server
  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    signal.relayHosts = ["10.10.2.45"];
  };

  # Force X11 (disable Wayland for RustDesk compatibility)
  services.displayManager.defaultSession = "plasmax11";

  # Headless display configuration for QEMU VM
  services.xserver = {
    # Use dummy driver for virtual display
    videoDrivers = ["dummy"];

    # Configure virtual display
    monitorSection = ''
      HorizSync   30.0 - 83.0
      VertRefresh 50.0 - 85.0
      # Virtual 1920x1080 display
      Modeline "1920x1080" 148.50 1920 2008 2052 2200 1080 1084 1089 1125
    '';

    deviceSection = ''
      VideoRam 256000
    '';

    screenSection = ''
      DefaultDepth 24
      SubSection "Display"
        Depth 24
        Modes "1920x1080"
      EndSubSection
    '';
  };

  # Auto-login for headless operation
  services.displayManager.autoLogin = {
    enable = true;
    user = "dave";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "pure";
    dhcpcd.enable = false;
    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "10.10.2.45";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "10.10.2.1";
    nameservers = ["10.10.10.2"];

    firewall = {
      enable = true;
      allowedTCPPorts = [80 443];
    };
    nftables.enable = true;

    enableIPv6 = false;
  };

  services.lldpd.enable = true;
  services.qemuGuest.enable = true;

  services.openssh.openFirewall = true;

  remote-builder.enable = true;

  ntfy = {
    enable = true;
    domain = "ntfy.poole.foo";
    enableAuth = false;
  };

  vaultwarden = {
    enable = true;
    domain = "vault.poole.foo";
  };
}
