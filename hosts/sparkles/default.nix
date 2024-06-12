{ inputs, outputs, ... }:

{

  networking.hostName = "sparkles";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common
      ../common/healthchecks-ping.nix
      ../common/tailscale.nix
      ../common/zram.nix
      ../common/restic-backups-local.nix
      ../common/postgres.nix
      ./gitea.nix

      inputs.agenix.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dave = import ../../home/dave;
          extraSpecialArgs = { inherit outputs; };
        };
      }
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking = {
    dhcpcd.enable = false;
    interfaces.enp3s0 = {
      ipv4.addresses = [{
        address = "38.175.196.184";
        prefixLength = 24;
      }];
      ipv6.addresses = [{
        address = "2606:a8c0:101:ca::a";
        prefixLength = 64;
      }];
    };
    defaultGateway = "38.175.196.1";
    defaultGateway6 = {
      address = "2606:a8c0:100::1";
      interface = "enp3s0";
    };
    nameservers = [ "9.9.9.9" "1.1.1.1" ];
  };

  # turn on firewall. only allow ssh from tailscale interface
  networking.firewall.enable = true;
  services.openssh.openFirewall = false;

  age.secrets.hc_ping.file = ../../secrets/sparkles_hc_ping_uuid.age;

}
