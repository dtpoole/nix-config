{inputs, ...}: let
  username = "dave";
in {

  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = import ../../modules/home-manager;
        extraSpecialArgs = {inherit username;};
      };
    }
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Optimize for virtualized environment
  boot.kernelParams = [ "elevator=noop" ];

  networking = {
    hostName = "pure";
    dhcpcd.enable = true;

    firewall.enable = true;
    nftables.enable = true;
  };

  services.openssh.openFirewall = false;

  services.beszel-agent.enable = true;
  services.qemuGuest.enable = true;

  dns.enable = true;
  healthchecks-ping.enable = false;
  netdata.enable = false;
  postgres.enable = false;
  restic.enable = false;
  tailscale.enable = true;
  zram.enable = true;
}
