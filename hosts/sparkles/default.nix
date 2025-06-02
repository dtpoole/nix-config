{
  networking.hostName = "sparkles";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ./gitea.nix
    ./acme.nix
    ./nginx.nix
    ./it-tools.nix
    ./linkding.nix
    ./searxng.nix
    ./miniflux.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking = {
    dhcpcd.enable = false;
    interfaces.enp3s0 = {
      ipv4.addresses = [
        {
          address = "66.23.198.201";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2606:a8c0:101:ca::a";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway = "66.23.198.1";
    defaultGateway6 = {
      address = "2606:a8c0:100::1";
      interface = "enp3s0";
    };
  };

  # turn on firewall. only allow ssh from tailscale interface
  networking = {
    firewall.enable = true;
    nftables.enable = true;
  };

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

  services.beszel-agent.enable = true;

  dns.enable = true;
  healthchecks-ping.enable = true;
  netdata.enable = false;
  postgres.enable = true;
  restic.enable = true;
  tailscale = {
    enable = true;
    useAuthKey = true;
  };
  zram.enable = true;
}
