{
  services.openssh = {
    allowSFTP = true; # Don't set this if you need sftp

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
    openFirewall = true;
  };
}
