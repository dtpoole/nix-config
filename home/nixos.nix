{ pkgs, username, ... }:

{

  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$gmxeDrPZuC4w8BUb.sy0Y0$I79zQJQbz9v9PF29tmq5mKe1m.At9Lvgtnh5D2VkZk1";
  };

  environment.shells = with pkgs; [ zsh ];

}