{ inputs, outputs, lib, modulesPath, ... }:

{

  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    (modulesPath + "/virtualisation/lxc-container.nix")
    ../../modulez/common.nix
    ../../modulez/user.nix
    ../../modulez/sshd.nix
    ../../modulez/postgres.nix
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



  networking.enableIPv6 = false;
  networking.nameservers = [ "10.10.10.1" ];

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 80 443 ];
  };

}
