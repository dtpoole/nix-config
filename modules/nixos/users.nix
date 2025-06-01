{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    users.enable = lib.mkEnableOption "enables users module";
  };

  config = lib.mkIf config.users.enable {
    users = {
      mutableUsers = false;
      users.dave = {
        isNormalUser = true;
        home = "/home/dave";
        group = "users";
        description = lib.mkForce "David Poole";
        extraGroups = ["docker" "wheel" "networkmanager"];
        hashedPassword = "$6$faPngAjiSid77.8t$8iLvE/E.ChK2GD.52gp4oMqG7gY.Gyd2TkfV.solZF9SMKSTmjGhkN.nJDwS26QLjAo3aAf4PCbEqrWJN2/cZ/";
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL8vV4xFbHiAkqYOSgwT2hdTVtnXqH5yC2mZEsQUnuJ"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8vKcWXqq+nA88NE2/mfCpu1bR1w8OJtJRTfTVqbbLR"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILcId6n5aN76tFqvdA42ECtsICDyh/1l+pC841ZBgENL"
        ];
      };
    };

    programs.zsh.enable = true;
    environment.shells = with pkgs; [zsh];
  };
}
