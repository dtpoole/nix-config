{
  pkgs,
  lib,
  config,
  username,
  name,
  ...
}: {
  options = {
    users.enable = lib.mkEnableOption "enables users module";
  };

  config = lib.mkIf config.users.enable {
    age.secrets.user_password = {
      file = ../../secrets/user_password.age;
    };

    users = {
      mutableUsers = false;
      users.${username} = {
        isNormalUser = true;
        home = "/home/${username}";
        group = "users";
        description = lib.mkForce name;
        extraGroups = ["docker" "wheel" "networkmanager"];
        hashedPasswordFile = config.age.secrets.user_password.path;
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
