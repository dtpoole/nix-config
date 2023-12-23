{ config, inputs, outputs, ... }:

{

  networking.hostName = "crunch";

  imports =
    [
      ./hardware-configuration.nix
      ../common
      ../common/user.nix
      ../common/zram.nix
      ../common/sshd.nix
      ../common/tailscale.nix
      ../common/healthchecks-ping.nix
      ../common/postgres.nix
      ./acme.nix
      ./backups.nix
      ./monitoring.nix
      ./containers.nix

      inputs.agenix.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dave = import ../../home/dave/crunch.nix;
          extraSpecialArgs = { inherit outputs; };
        };
      }

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

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
    ];
    config = {
      allowUnfree = true;
    };
  };

  virtualisation.docker.enable = true;

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
      "tools.poole.foo" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8070";
          proxyWebsockets = true;
        };
        addSSL = true;
        useACMEHost = "tools.poole.foo";
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  age.secrets.hc_ping.file = ../../secrets/crunch_hc_ping_uuid.age;
  age.secrets.hc_backup.file = ../../secrets/crunch_hc_backup_uuid.age;

  # set user password
  age.secrets.user_password.file = ../../secrets/user_password.age;
  users.users.dave.hashedPasswordFile = config.age.secrets.user_password.path;

}
