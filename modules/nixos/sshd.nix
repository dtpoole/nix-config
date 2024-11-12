{
  lib,
  config,
  ...
}: {
  options = {
    sshd.enable = lib.mkEnableOption "enables sshd";
  };

  config = lib.mkIf config.sshd.enable {
    services.openssh = {
      enable = true;
      allowSFTP = true;

      settings = {
        X11Forwarding = false;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
      extraConfig = ''
        AllowTcpForwarding yes
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
      '';
    };
  };
}
