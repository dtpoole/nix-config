{ pkgs, ... }:

{

  networking.hostName = "vm1";

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common
      ../common/user.nix
      ../common/desktop.nix
      #../../modulez/zram.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

}