{ inputs, outputs, ... }:

{

  networking.hostName = "vm1";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports =
    [
      ./hardware-configuration.nix
      ../common
      ../common/desktop.nix

      inputs.agenix.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dave = import ../../home/dave/desktop.nix;
          extraSpecialArgs = { inherit outputs; };
        };
      }
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  services.qemuGuest.enable = true;

}
