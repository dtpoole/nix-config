{ config, inputs, outputs, ... }:

{

  networking.hostName = "crunch";

  imports =
    [
      ./hardware-configuration.nix
      ../common
      ../common/zram.nix
      ../common/restic-backups.nix
      ../common/tailscale.nix
      ../common/healthchecks-ping.nix
      ../common/netdata.nix
      ../common/postgres.nix
      ./acme.nix
      ./monitoring.nix
      ./containers.nix
      ./nginx.nix

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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };

  networking.enableIPv6 = false;

  # security.auditd.enable = true;
  # security.audit.enable = true;
  # security.audit.rules = [
  #   "-a exit,always -F arch=b64 -S execve"
  # ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
    ];
    config = {
      allowUnfree = true;
    };
  };

  virtualisation.docker.enable = false;

  age.secrets.hc_ping.file = ../../secrets/crunch_hc_ping_uuid.age;
  age.secrets.hc_backup.file = ../../secrets/crunch_hc_backup_uuid.age;

  programs.mosh.enable = true;

}
