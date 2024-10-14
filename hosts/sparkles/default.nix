{ inputs, ... }:
let
  username = "dave";
in
{

  networking.hostName = "sparkles";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
      ./gitea.nix
      ./acme.nix
      ./nginx.nix
      ./it-tools.nix
      ./linkding.nix
      ./searxng.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = import ../../modules/home-manager;
          extraSpecialArgs = { inherit username; };
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

  virtualisation.podman.autoPrune = {
    enable = true;
    flags = [
      "--all"
    ];
  };

  age.secrets = {
    hc_ping.file = ../../secrets/sparkles_hc_ping_uuid.age;

    "restic/env".file = ../../secrets/restic/cloud/env.age;
    "restic/repo".file = ../../secrets/restic/cloud/repo.age;
    "restic/password".file = ../../secrets/restic/cloud/password.age;
    "restic/hc_uuid".file = ../../secrets/sparkles_hc_restic_uuid.age;

    searxng_secret.file = ../../secrets/searxng_secret.age;
  };

  healthchecks-ping.enable = true;
  netdata.enable = true;
  postgres.enable = true;
  restic.enable = true;
  tailscale.enable = true;
  zram.enable = true;

}
