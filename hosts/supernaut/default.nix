{ inputs, outputs, lib, modulesPath, ... }:

{

  networking.hostName = "supernaut";

  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    (modulesPath + "/virtualisation/lxc-container.nix")
    ../common
    ../common/postgres.nix
    ../common/healthchecks-ping.nix
    ../common/netdata.nix
    ../common/restic.nix
    ../common/tailscale.nix
    # ./gitea.nix
    # ./acme.nix
    # ./nginx.nix
    ./vaultwarden.nix

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

  networking.enableIPv6 = true;
  networking.nameservers = [ "10.10.10.1" ];

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 22 80 443 ];
  };

  age.secrets = {
    hc_ping.file = ../../secrets/supernaut_hc_ping_uuid.age;
    hc_backup.file = ../../secrets/supernaut_hc_backup_uuid.age;
    vaultwarden_admin_token.file = ../../secrets/supernaut_vaultwarden_admin_token.age;

    "restic/repo".file = ../../secrets/restic/local/repo.age;
    "restic/password".file = ../../secrets/restic/local/password.age;
    "restic/hc_uuid".file = ../../secrets/supernaut_hc_restic_uuid.age;
  };

  programs.mosh.enable = true;

  # restic overrides
  services.restic.backups.daily = {
    # backupCleanupCommand = lib.mkForce null;
    environmentFile = lib.mkForce null;
  };

}
