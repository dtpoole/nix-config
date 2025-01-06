{inputs, ...}: let
  username = "dave";
in {
  networking.hostName = "jumbo";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ./containers.nix
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

  boot.tmp.cleanOnBoot = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking = {
    dhcpcd.enable = false;
    interfaces.enp3s0 = {
      ipv4.addresses = [
        {
          address = "104.36.87.94";
          prefixLength = 22;
        }
      ];
      ipv6.addresses = [
        {
          address = "2606:a8c0:3:929::a";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway = "104.36.84.1";
    defaultGateway6 = {
      address = "2606:a8c0:3::1";
      interface = "enp3s0";
    };
    nameservers = ["9.9.9.9" "1.1.1.1"];
  };

  # turn on firewall. only allow ssh from tailscale interface
  networking.firewall.enable = true;
  services.openssh.openFirewall = false;

  age.secrets.hc_ping.file = ../../secrets/jumbo_hc_ping_uuid.age;

  autoupgrade.enable = false;
  tailscale.enable = true;
  zram.enable = true;
  healthchecks-ping.enable = true;
}
