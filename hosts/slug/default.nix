{ inputs, outputs, ... }:

{

  networking.hostName = "slug";
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
          users.dave = import ../../home/dave;
          extraSpecialArgs = { inherit outputs; };
        };
      }
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.kernel.sysctl = { "vm.swappiness" = 25; };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  services.xrdp.enable = true;

  hardware.cpu.intel.updateMicrocode = true;

}
