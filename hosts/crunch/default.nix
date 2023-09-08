{ config, pkgs, username, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modulez/zram.nix
      ../../modulez/sshd.nix
      ../../modulez/tailscale.nix
      ../../modulez/healthchecks-ping.nix
      ./acme.nix
      ./backups.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  networking.enableIPv6 = false;

  # security.auditd.enable = true;
  # security.audit.enable = true;
  # security.audit.rules = [
  #   "-a exit,always -F arch=b64 -S execve"
  # ];

  virtualisation.docker.enable = true;
  users.users.${username}.extraGroups = [ "docker" ];

  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "git.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3030";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "git.poole.foo";
      };
      "links.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:9090";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "links.poole.foo";
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  age.secrets.hc_ping.file = ../../secrets/crunch_hc_ping_uuid.age;

  system.stateVersion = "23.05"; # Did you read the comment?

}

