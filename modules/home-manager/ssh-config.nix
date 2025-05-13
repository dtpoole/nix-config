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
        HashKnownHosts yes
        # trusted network
        Host 10.10.2.*
            StrictHostKeyChecking accept-new
        Host *
          StrictHostKeyChecking yes

        # multiplexing
        ControlMaster auto
        ControlPath ~/.ssh/control/%r@%h:%p
        ControlPersist 10m
      '';
      matchBlocks = {
        "tank" = {
          hostname = "10.10.10.40";
          user = "tank";
        };
        "mini" = {
          hostname = "10.10.10.60";
        };
        "jellyfin" = {
          hostname = "10.10.10.35";
          user = "root";
        };
        "plex" = {
          hostname = "10.10.10.36";
          user = "root";
        };
        "slurp" = {
          hostname = "10.10.10.37";
          user = "media";
        };
        "caddy" = {
          hostname = "10.10.10.39";
          user = "root";
        };
        "minecraft" = {
          hostname = "10.10.10.145";
          user = "root";
        };
        "minecraft-java" = {
          hostname = "10.10.10.146";
          user = "root";
        };
      };
    };

    # Ensure control directory exists
    home.file.".ssh/control/.keep".text = "";
  };
}
