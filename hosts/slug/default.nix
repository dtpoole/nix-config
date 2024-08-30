{

  networking.hostName = "slug";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
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

  desktop.enable = true;

}
