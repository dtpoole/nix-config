{ config, pkgs, lib, username, ... }: {

  imports = [
    ./default.nix
    ./kitty.nix
  ];

  kitty.enable = lib.mkDefault true;
}
