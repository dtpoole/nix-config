{ config, pkgs, ... }:

{

  age.secrets.acme_credentials.file = ../../secrets/acme_cloudflare_credentials.age;

  security.acme = {
    defaults = {
      email = "acme@poole.foo";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = false;
      credentialsFile = "${config.age.secrets.acme_credentials.path}";
    };
    acceptTerms = true;
    certs = {
      "crunch.poole.foo" = {
        extraDomainNames = [ "*.crunch.poole.foo" ];
      };
      "git.poole.foo" = { };
      "links.poole.foo" = { };
    };
  };

}
