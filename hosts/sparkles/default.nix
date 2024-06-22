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
      ../common/restic.nix
      ../common/postgres.nix
      ../common/netdata.nix
      ./gitea.nix
      ./acme.nix
      ./nginx.nix
      ./it-tools.nix
      ./linkding.nix

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

  # restic
  age.secrets.restic_hc_uuid.file = ../../secrets/sparkles_hc_restic_uuid.age;
  age.secrets.restic_repository.file = ../../secrets/restic_cloud_repository.age;
  age.secrets.restic_password.file = ../../secrets/restic_cloud_password.age;
  age.secrets.restic_environment.file = ../../secrets/restic_cloud_environment.age;

}
