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
    age.secrets.user_password.file = ../../secrets/user_password.age;

    users.users.dave = {
      isNormalUser = true;
      home = "/home/dave";
      group = "users";
      description = lib.mkForce "David Poole";
      extraGroups = ["docker" "wheel" "networkmanager"];
      hashedPasswordFile = config.age.secrets.user_password.path;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL8vV4xFbHiAkqYOSgwT2hdTVtnXqH5yC2mZEsQUnuJ"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8vKcWXqq+nA88NE2/mfCpu1bR1w8OJtJRTfTVqbbLR"
      ];
    };

    programs.zsh.enable = true;
    environment.shells = with pkgs; [zsh];
  };
}
