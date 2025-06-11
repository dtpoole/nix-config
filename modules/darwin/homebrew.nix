{
  config,
  lib,
  ...
}: let
  cfg = config.darwin.homebrew;
in {
  options.darwin.homebrew = {
    extraCasks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional Homebrew casks to install";
    };

    extraBrews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional Homebrew formulas to install";
    };

    extraMasApps = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
      default = {};
      description = "Additional Mac App Store apps to install";
    };
  };

  config = {
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };

      global.autoUpdate = true;

      brews =
        [
          "mas"
        ]
        ++ cfg.extraBrews;

      casks =
        [
          "1password"
          "acorn"
          "claude"
          "discord"
          "ghostty"
          "google-chrome"
          "itsycal"
          "jordanbaird-ice"
          "launchbar"
          "lunar"
          "netnewswire"
          "obsidian"
          "omnidisksweeper"
          "plexamp"
          "transmit"
          "transnomino"
          "utm"
          "visual-studio-code"
          "vlc"
          "zed"
          "font-fira-code"
          "font-monaspace"
          "font-jetbrains-mono"
        ]
        ++ cfg.extraCasks;

      masApps =
        {
          "1Password for Safari" = 1569813296;
          "Copilot: Track & Budget Money" = 1447330651;
          "Drafts" = 1435957248;
          "Enchanted LLM" = 6474268307;
          "PCalc" = 403504866;
          "Tailscale" = 1475387142;
          "Keynote" = 409183694;
          "Numbers" = 409203825;
          "Pages" = 409201541;
          "StopTheMadness Pro" = 6471380298;
          "Infuse • Video Player" = 1136220934;
        }
        // cfg.extraMasApps;
    };
  };
}
