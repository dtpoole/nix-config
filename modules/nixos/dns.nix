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

      # Use these DNS servers
      fallbackDns = [
        "9.9.9.9" # Quad9
        "1.1.1.1" # Cloudflare
        "8.8.8.8" # Google
      ];

      # These settings can be adjusted according to preference
      extraConfig = ''
        DNSOverTLS=opportunistic
        MulticastDNS=no
        LLMNR=no
        Cache=yes
        CacheFromLocalhost=no
        DNSStubListener=no
        DNSStubListenerExtra=127.0.0.1
      '';
    };

    # This ensures that /etc/resolv.conf points to systemd-resolved
    networking.nameservers = lib.mkForce ["127.0.0.53"];
    networking.networkmanager.dns = "systemd-resolved";
  };
}
