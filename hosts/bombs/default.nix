{ config, inputs, outputs, ... }:

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

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
    ];
    config = {
      allowUnfree = true;
    };
  };

  virtualisation.docker.enable = false;

  programs.mosh.enable = true;

}
