{
  lib,
  config,
  ...
}: let
  cfg = config.ntfy;
in {
  options = {
    ntfy = {
      enable = lib.mkEnableOption "enables ntfy server";

      domain = lib.mkOption {
        type = lib.types.str;
        example = "ntfy.example.com";
        description = "Domain name for ntfy service";
      };

      enableAuth = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable authentication";
      };
    };
  };

  config = lib.mkIf config.ntfy.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${cfg.domain}";
        listen-http = "127.0.0.1:2586";
        cache-file = "/var/lib/ntfy-sh/cache.db";
        attachment-cache-dir = "/var/lib/ntfy-sh/attachments";
        behind-proxy = true;
        upstream-base-url = "https://ntfy.sh";

        # Authentication settings
        auth-file = lib.mkIf cfg.enableAuth "/var/lib/ntfy-sh/user.db";
        auth-default-access = lib.mkIf cfg.enableAuth "deny-all";
        enable-login = lib.mkIf cfg.enableAuth true;
      };
    };

    system.activationScripts.ntfy-info = ''
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "ntfy is configured at: https://${cfg.domain}"
      ${
        if cfg.enableAuth
        then ''
          echo "Authentication is ENABLED"
          echo "Create a user with: sudo ntfy user add --role=admin USERNAME"
        ''
        else ''
          echo "WARNING: Authentication is DISABLED"
        ''
      }
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';
  };
}
