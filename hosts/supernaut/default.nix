{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/lxc-container.nix")
    ../../modulez/sshd.nix
    ../../modulez/postgres.nix
    ./gitea.nix
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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  networking.enableIPv6 = false;
  networking.nameservers = [ "10.10.10.1" ];

}