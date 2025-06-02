{
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

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

    firewall.enable = true;
    nftables.enable = true;
  };

  services.lldpd.enable = true;

  services.openssh.openFirewall = true;

  services.beszel-agent.enable = true;
  services.qemuGuest.enable = true;

  dns.enable = false;
  healthchecks-ping.enable = false;
  netdata.enable = false;
  postgres.enable = false;
  restic.enable = false;
  tailscale.enable = false;
  zram.enable = true;
}
