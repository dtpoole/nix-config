{config, ...}: {
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
      "sparkles.poole.foo" = {
        extraDomainNames = ["*.sparkles.poole.foo"];
      };
      "git.poole.foo" = {};
      "tools.poole.foo" = {};
      "links.poole.foo" = {};
      "search.poole.foo" = {};
    };
  };
}
