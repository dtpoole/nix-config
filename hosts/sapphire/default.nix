{
  networking.hostName = "sapphire";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/vps.nix
    ./containers.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking = {
    dhcpcd.enable = false;
    interfaces.enp3s0 = {
      ipv4.addresses = [
        {
          address = "216.126.234.108";
          prefixLength = 22;
        }
      ];
      ipv6.addresses = [
        {
          address = "2606:a8c0:3:152::a";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway = "216.126.232.1";
    defaultGateway6 = {
      address = "2606:a8c0:3::1";
      interface = "enp3s0";
    };
  };

  # turn on firewall. only allow ssh from tailscale interface
  networking = {
    firewall.enable = true;
    nftables.enable = true;
  };

  age.secrets = {
    hc_ping.file = ../../secrets/sapphire_hc_ping_uuid.age;
  };

  profiles.vps.enable = true;
}
