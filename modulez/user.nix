{ config, pkgs, username, ... }:

{

  age.secrets.user_password.file = ../secrets/user_password.age;

  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
    passwordFile = config.age.secrets.user_password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL8vV4xFbHiAkqYOSgwT2hdTVtnXqH5yC2mZEsQUnuJ dave@mini"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8HIreGLHjE8f2kpfd49WRCfXXk2oMRApuIW78BWYVi dave@air"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBiPje/UdwOPDQPQdt7AjzYRg6c4DhgxuoG2IJAlIbs+SzOAGN82j9T19wce9/nK4y4QddNCDCNRJiUKRPDepWk="
    ];
  };

  environment.shells = with pkgs; [ zsh ];

}
