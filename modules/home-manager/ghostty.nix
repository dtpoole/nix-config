{
  lib,
  config,
  ...
}: {
  options = {
    ghostty.enable = lib.mkEnableOption "enables ghostty";
  };

  config = lib.mkIf config.ghostty.enable {
    xdg.configFile."ghostty/config".text = ''
      alpha-blending = linear-corrected
      font-size = 13.500000
      theme = nord
      window-height = 50
      window-width = 200
    '';
  };
}
