{ pkgs, lib, config, ... }: {

  options = {
    ssh.enable = lib.mkEnableOption "enables ssh";
  };

  config = lib.mkIf config.ssh.enable {
    programs.ssh = {
      enable = true;
      extraConfig = ''
        StrictHostKeyChecking no
      '';
      matchBlocks = {
        "tank" = {
          hostname = "10.10.10.40";
          user = "tank";
        };
        "mini" = {
          hostname = "10.10.10.50";
        };
        "slug" = {
          hostname = "10.10.10.60";
        };
        "supernaut" = {
          hostname = "10.10.10.120";
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
        "soma" = {
          hostname = "soma.poole.foo";
          port = 5829;
        };

      };
    };
  };

}
