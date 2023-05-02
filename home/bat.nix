{ config, lib, pkgs, ... }: {

  programs.bat = {
    enable = true;
    config = {
      italic-text = "always";
      tabs = "2";
      theme = "Nord"; # currently broken
    };
  };
}
