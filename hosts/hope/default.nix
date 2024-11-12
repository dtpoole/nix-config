{inputs, ...}: let
  username = "dave";
in {
  networking.hostName = "hope";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
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
          address = "38.175.197.14";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2606:a8c0:101:c3::a";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway = "38.175.197.1";
    defaultGateway6 = {
      address = "2606:a8c0:100::1";
      interface = "enp3s0";
    };
    nameservers = ["9.9.9.9" "1.1.1.1"];
  };

  # turn on firewall. only allow ssh from tailscale interface
  networking.firewall.enable = true;
  services.openssh.openFirewall = false;

  age.secrets.hc_ping.file = ../../secrets/hope_hc_ping_uuid.age;

  autoupgrade.enable = true;
  tailscale.enable = true;
  zram.enable = true;
  healthchecks-ping.enable = true;
}
