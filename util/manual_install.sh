#!/usr/bin/env bash

# UEFI manual install steps with 1g swap

parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MB -1GB
parted /dev/sda -- mkpart primary linux-swap -1GB 100%
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 3 esp on

mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3

mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

swapon /dev/sda2

nixos-generate-config --root /mnt


ifconfig enp3s0 38.175.196.184 netmask 255.255.255.0;
route add default gw 38.175.196.1 enp3s0;
echo 'nameserver 1.1.1.1' > /etc/resolv.conf

parted /dev/sda -- mklabel msdos;
parted /dev/sda -- mkpart primary 1MB -2GB;
parted /dev/sda -- set 1 boot on;
parted /dev/sda -- mkpart primary linux-swap -2GB 100%


#     networking = {
#       hostName = "daze";
#       dhcpcd.enable = false;
#       interfaces.enp3s0.ipv4.addresses = [{
#         address = "38.175.196.184";
#         prefixLength = 24;
#       }];

#       defaultGateway = "38.175.196.1";
#       nameservers = [ "9.9.9.9", "1.1.1.1" ];
#     };
# users.users."root".openssh.authorizedKeys.keys = [
#   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL8vV4xFbHiAkqYOSgwT2hdTVtnXqH5yC2mZEsQUnuJ"
# ];

