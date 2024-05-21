{ config, inputs, outputs, ... }:

{

  networking.hostName = "hope";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common

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


  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

 
  system.stateVersion = "23.11"; # Did you read the comment?


    networking = {
      dhcpcd.enable = false;
      interfaces.enp3s0.ipv4.addresses = [{
        address = "38.175.197.14";
        prefixLength = 24;
      }];
     
      defaultGateway = "38.175.197.1";
      nameservers = [ "9.9.9.9" "1.1.1.1" ];
    };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL8vV4xFbHiAkqYOSgwT2hdTVtnXqH5yC2mZEsQUnuJ"
  ];
}