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

      theme = nord
      window-height = 40
      window-width = 150

      font-family = "Berkeley Mono Variable"
      font-size = 15.500000

      # Font width (60 to 100)
      #  60 = UltraCondensed
      #  70 = ExtraCondensed
      #  80 = Condensed
      #  90 = SemiCondensed
      # 100 = Normal
      font-variation = wdth=90

      # Font weight (100 to 900)
      # 100 = Thin
      # 200 = ExtraLight
      # 300 = Light
      # 350 = SemiLight
      # 400 = Regular
      # 500 = Medium
      # 600 = SemiBold
      # 700 = Bold
      # 800 = ExtraBold
      # 900 = Black
      font-variation = wght=400

      # Font slant (0 to -16)
      #   0 = Regular
      # -16 = Oblique
      font-variation = slnt=0

      # otfinfo -f ~/.local/share/fonts/Berkeley\ Mono\ Variable.otf
      # aalt    Access All Alternates
      # calt    Contextual Alternates
      # ccmp    Glyph Composition/Decomposition
      # mark    Mark Positioning
      # mkmk    Mark to Mark Positioning
      # salt    Stylistic Alternates
      # ss01    Stylistic Set 1 <- slashed 0
      # ss02    Stylistic Set 2 <- dotted 0
      # ss03    Stylistic Set 3 <- gap 0
      # ss04    Stylistic Set 4 <- slashed 0, slash 7
      # ss05    Stylistic Set 5 <- dotted 0, slash 7
      # ss06    Stylistic Set 6 <- gap 0, slash 7
      font-feature = +calt
      font-feature = +ss01
    '';
  };
}
