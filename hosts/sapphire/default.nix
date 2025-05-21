{inputs, ...}: let
  username = "dave";
in {
  networking.hostName = "sapphire";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    ./containers.nix
    ./hardware-configuration.nix
    ../../modules/nixos

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = import ../../modules/home-manager;
        extraSpecialArgs = {inherit username;};
      };
    }
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

  documentation.nixos.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  #  remove build dependencies
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = false
  '';

  services.openssh.openFirewall = false;

  services.beszel-agent.enable = true;

  age.secrets = {
    hc_ping.file = ../../secrets/sapphire_hc_ping_uuid.age;
  };

  dns.enable = true;
  healthchecks-ping.enable = true;
  netdata.enable = false;
  postgres.enable = false;
  restic.enable = false;
  tailscale.enable = true;
  zram.enable = true;
}
