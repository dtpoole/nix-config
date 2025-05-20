{
  lib,
  config,
  ...
}: {
  options = {
    ssh-config.enable = lib.mkEnableOption "enables ssh";
  };

  config = lib.mkIf config.ssh-config.enable {
    programs.ssh = {
      enable = true;
      extraConfig = ''
        # trusted network
        Host 10.10.2.*
          StrictHostKeyChecking accept-new
      '';
      controlMaster = "auto";
      controlPersist = "4h";
      hashKnownHosts = true;

      matchBlocks = {
        "tank" = {
          hostname = "10.10.2.40";
          user = "tank";
        };
        "mini" = {
          hostname = "10.10.2.60";
        };
        "jellyfin" = {
          hostname = "10.10.2.35";
          user = "root";
        };
        "plex" = {
          hostname = "10.10.2.36";
          user = "root";
        };
        "slurp" = {
          hostname = "10.10.2.37";
          user = "media";
        };
        "caddy" = {
          hostname = "10.10.2.39";
          user = "root";
        };
        "minecraft" = {
          hostname = "10.10.2.145";
          user = "root";
        };
        "minecraft-java" = {
          hostname = "10.10.2.146";
          user = "root";
        };
      };
    };
  };
}
