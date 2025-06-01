{inputs, ...}: let
  username = "dave";
in {
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Optimize for virtualized environment
  boot.kernelParams = ["elevator=noop"];

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
