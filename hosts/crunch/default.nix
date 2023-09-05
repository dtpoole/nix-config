{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modulez/zram.nix
      ../../modulez/sshd.nix
      ../../modulez/tailscale.nix
      ../../modulez/healthchecks-ping.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;

  networking.firewall.enable = true;

  networking.enableIPv6 = false;

  age.secrets.hc_ping.file = ../../secrets/crunch_hc_ping_uuid.age;

  # security.auditd.enable = true;
  # security.audit.enable = true;
  # security.audit.rules = [
  #   "-a exit,always -F arch=b64 -S execve"
  # ];

  system.stateVersion = "23.05"; # Did you read the comment?


  age.secrets.acme_credentials.file = ../../secrets/acme_cloudflare_credentials.age;

  security.acme = {
    defaults = {
      email = "acme@poole.foo";
    };
    acceptTerms = true;
    certs = {
      "crunch.poole.foo" = {
        domain = "crunch.poole.foo";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        credentialsFile = ${config.age.secrets.acme_credentials.path};
        extraDomainNames = [ "*.crunch.poole.foo" ];
        dnsPropagationCheck = false;
      };
    };
  };

}

