{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    profiles.vps.enable = lib.mkEnableOption "VPS profile with cloud-optimized defaults";
  };

  config = lib.mkIf config.profiles.vps.enable {

    documentation.nixos.enable = false;
    documentation.man.enable = false;
    documentation.info.enable = false;
    documentation.doc.enable = false;

    #  remove build dependencies
    nix.extraOptions = ''
      keep-outputs = true
      keep-derivations = false
    '';

    services.journald = {
      extraConfig = ''
        SystemMaxUse=100M
        RuntimeMaxUse=50M
        MaxFileSec=7day
        RateLimitInterval=30s
        RateLimitBurst=1000
        Storage=persistent
        Compress=yes
        ForwardToSyslog=no
      '';
    };

    systemd.coredump = {
      enable = true;
      extraConfig = "Storage=none";
    };

    tailscale = {
      enable = true;
      useAuthKey = true;
    };

  };

}
