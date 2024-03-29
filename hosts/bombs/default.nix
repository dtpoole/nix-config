{ inputs, outputs, lib, modulesPath, ... }:

{

  networking.hostName = "bombs";

  nixpkgs.hostPlatform = "x86_64-linux";

  imports =
    [
      (modulesPath + "/virtualisation/lxc-container.nix")
      ./hardware-configuration.nix
      ../common
      ../common/tailscale.nix
      ../common/netdata.nix
      ../common/postgres.nix
      ../common/restic-backups.nix
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

  # Supress systemd units that don't work because of LXC
  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  # start tty0 on serial console
  systemd.services."getty@tty1" = {
    enable = lib.mkForce true;
    wantedBy = [ "getty.target" ]; # to start at boot
    serviceConfig.Restart = "always"; # restart when session is closed
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
    ];
    config = {
      allowUnfree = true;
    };
  };

  networking.enableIPv6 = false;
  networking.nameservers = [ "10.10.10.1" ];

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 22 80 443 ];
  };

  programs.mosh.enable = true;

  virtualisation.oci-containers.containers."it-tools" = {
    autoStart = true;
    image = "corentinth/it-tools:2023.12.21-5ed3693";
    extraOptions = [ "--pull=always" ];
    ports = [ "8070:80" ];
  };

    age.secrets.hc_backup.file = ../../secrets/bombs_hc_backup_uuid.age;

}
