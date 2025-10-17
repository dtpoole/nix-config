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
        PermitRootLogin = "no";

        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group-exchange-sha256"
        ];
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
          "aes256-ctr"
          "aes192-ctr"
          "aes128-ctr"
        ];
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];

        MaxAuthTries = 3;
        MaxSessions = 10;
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
        LoginGraceTime = 60;
      };

      extraConfig = ''
        AllowTcpForwarding yes
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey

        # Rate limiting
        MaxStartups 10:30:60
      '';
    };
  };
}
