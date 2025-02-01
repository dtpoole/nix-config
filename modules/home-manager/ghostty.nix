{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    ghostty.enable = lib.mkEnableOption "enables ghostty";
  };

  config = lib.mkIf config.ghostty.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "nord";
        window-height = 50;
        window-width = 200;
        font-size = 13.5;
        alpha-blending = "linear-corrected";
      };
    };
  };
}
