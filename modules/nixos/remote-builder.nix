{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    remote-builder.enable = lib.mkEnableOption "enables remote building capabilities";
  };

  config = lib.mkIf config.remote-builder.enable {
    # Enable nix-serve for serving built packages
    services.nix-serve = {
      enable = true;
      port = 5000;
      bindAddress = "0.0.0.0";
    };

    # Allow remote building
    nix.settings = {
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
    };

    # Open firewall for nix-serve
    networking.firewall.allowedTCPPorts = [5000];

    # Enable SSH for remote building
    programs.ssh.extraConfig = ''
      Host sparkles
        HostName sparkles.fish-diminished.ts.net
        User dave
        IdentitiesOnly yes
        StrictHostKeyChecking accept-new
    '';
  };
}
