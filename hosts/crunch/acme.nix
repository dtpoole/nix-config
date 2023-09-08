{ config, pkgs, ... }:

{  
  
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
        credentialsFile = "${config.age.secrets.acme_credentials.path}";
        extraDomainNames = [ "*.crunch.poole.foo" ];
        dnsPropagationCheck = false;
      };
      "git.poole.foo" = {
        domain = "git.poole.foo";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        credentialsFile = "${config.age.secrets.acme_credentials.path}";
        dnsPropagationCheck = false;
      };
 
    };
  };

}