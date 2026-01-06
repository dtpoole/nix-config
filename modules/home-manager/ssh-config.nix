{
  pkgs,
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
      enableDefaultConfig = false;

      extraConfig = lib.mkIf pkgs.stdenv.isDarwin ''
        UseKeychain yes
      '';

      matchBlocks = {
        "*" = {
          forwardAgent = false;
          compression = false;
          serverAliveInterval = 60;
          serverAliveCountMax = 3;
          hashKnownHosts = true;
          userKnownHostsFile = "~/.ssh/known_hosts";
          addKeysToAgent = "yes";
          controlMaster = "auto";
          controlPersist = "4h";
          controlPath = "~/.ssh/master-%r@%n:%p";
          identityFile = "~/.ssh/id_ed25519";
        };

        "10.10.2.*" = {
          extraOptions = {
            StrictHostKeyChecking = "accept-new";
          };
        };

        "tank" = {
          hostname = "10.10.2.40";
          user = "tank";
        };
        "pure" = {
          hostname = "10.10.2.45";
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

    services.ssh-agent = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
    };
  };
}
