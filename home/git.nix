{
  programs.git = {
    enable = true;
    userName = "David Poole";
    userEmail = "dtpoole@users.noreply.github.com";
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      up = "rebase";
      ci = "commit";
    };
    delta = {
      enable = true;
      options = {
        side-by-side = "true";
        theme = "Nord";
      };
    };
  };
}
