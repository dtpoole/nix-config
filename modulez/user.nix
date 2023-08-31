{ pkgs, username, ... }:

{

  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$gmxeDrPZuC4w8BUb.sy0Y0$I79zQJQbz9v9PF29tmq5mKe1m.At9Lvgtnh5D2VkZk1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL8vV4xFbHiAkqYOSgwT2hdTVtnXqH5yC2mZEsQUnuJ dave@mini"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8HIreGLHjE8f2kpfd49WRCfXXk2oMRApuIW78BWYVi dave@air"
    ];


  };

  environment.shells = with pkgs; [ zsh ];

}
