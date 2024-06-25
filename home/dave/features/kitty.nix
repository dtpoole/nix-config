{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{

  programs.kitty = {
    enable = true;

    settings = {

      font_family = "JetBrains Mono";
      font_size = if isDarwin then "12.0" else "10.0";

      # Window layout
      # hide_window_decorations = "titlebar-only";
      window_padding_width = "3";

      cursor_blink_interval = "0";

      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_activity_symbol = "◆";
      tab_title_template = "{fmt.fg.white}{bell_symbol}{activity_symbol} {fmt.fg.tab}{title}";

      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";

      enable_audio_bell = "no";
      visual_bell_duration = "0.5";

      macos_titlebar_color = "background";
      # macos_thicken_font = "0.75";

      shell_integration = "disabled";

    };

    theme = "Nord";
  };

}
