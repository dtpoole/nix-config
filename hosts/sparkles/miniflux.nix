{config, ...}:
{

  age.secrets.miniflux_admin.file = ../../secrets/miniflux_admin.age;

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux_admin.path;
  };

}