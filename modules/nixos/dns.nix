{
  lib,
  config,
  ...
}: {
  options = {
    dns.enable = lib.mkEnableOption "enables systemd-resolved for DNS resolution";
  };

  config = lib.mkIf config.dns.enable {
    # Enable systemd-resolved
    services.resolved = {
      enable = true;
      
      # DNS over TLS
      dnssec = "true";
      
      # Use these DNS servers (you can change these)
      fallbackDns = [
        "9.9.9.9"    # Quad9
        "1.1.1.1"    # Cloudflare
        "8.8.8.8"    # Google
      ];
      
      # These settings can be adjusted according to preference
      extraConfig = ''
        DNSOverTLS=opportunistic
        MulticastDNS=yes
        Cache=yes
        CacheFromLocalhost=no
      '';
    };

    # This ensures that /etc/resolv.conf points to systemd-resolved
    networking.nameservers = lib.mkForce [ "127.0.0.53" ];
    networking.networkmanager.dns = "systemd-resolved";
    
    # If you're using networkmanager, integrate with it
    networking.networkmanager.dynamicHosts.enable = true;
  };
}