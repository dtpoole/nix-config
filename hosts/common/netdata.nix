{
  services.netdata = {
    enable = true;

    config = {
      global = {
        "update every" = 15;
      };
      ml = {
        "enabled" = "yes";
      };
      web = {
        "bind to" = "127.0.0.1";
      };
    };
  };

}
