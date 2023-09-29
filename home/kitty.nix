{ pkgs, lib, hasGUI, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{

  programs.kitty = lib.mkIf hasGUI {
    enable = true;

    settings = {
      font_family = "Fira Code Light";
      font_size = if isDarwin then "13.0" else "12.0";
      bold_font = "Fira Code Retina";

      # Window layout
      # hide_window_decorations = "titlebar-only";
      window_padding_width = "3";

      cursor_blink_interval = "0";
      # Tab bar
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_title_template = "{index} {title}";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
      # tab_activity_symbol = "*";

      enable_audio_bell = "no";
      visual_bell_duration = "0.5";

      macos_titlebar_color = "background";
      macos_thicken_font = "0.75";

    };

    theme = "Nord";
  };

}
