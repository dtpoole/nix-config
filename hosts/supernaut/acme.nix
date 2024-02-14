{ config, ... }:

{

  age.secrets.acme_credentials.file = ../../secrets/acme_cloudflare_credentials.age;

  security.acme = {
    defaults = {
      email = "acme@poole.fun";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = false;
      credentialsFile = "${config.age.secrets.acme_credentials.path}";
    };
    acceptTerms = true;
    certs = {
      "supernaut.poole.foo" = {
        extraDomainNames = [ "*.supernaut.poole.foo" ];
      };
      "git.poole.foo" = { };
      "vault.poole.fun" = { };
    };
  };

}
