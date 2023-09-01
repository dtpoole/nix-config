{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modulez/zram.nix
      ../../modulez/sshd.nix
      ../../modulez/tailscale.nix
      ../../modulez/healthchecks-ping.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;

  networking.firewall.enable = true;

  networking.enableIPv6 = false;

  age.secrets.hc_ping.file = ../../secrets/crunch_hc_ping_uuid.age;

  system.stateVersion = "23.05"; # Did you read the comment?

}

