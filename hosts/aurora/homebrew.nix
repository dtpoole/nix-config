{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    global.autoUpdate = true;

    brews = [
      "mas"
    ];

    casks = [
      "1password"
      "acorn"
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
    ];

    masApps = {
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
    };
  };
}
