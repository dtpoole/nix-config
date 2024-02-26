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
