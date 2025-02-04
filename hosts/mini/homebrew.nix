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
      "colima"
      "docker"
      "flac"
      "libdvdcss"
      "mas"
    ];

    casks = [
      "1password"
      "acorn"
      "balenaetcher"
      "calibre"
      "fission"
      "ghostty"
      "google-chrome"
      "gzdoom"
      "handbrake"
      "ioquake3"
      "itsycal"
      "jordanbaird-ice"
      "kitty"
      "launchbar"
      "logi-options+"
      "lunar"
      "makemkv"
      "musicbrainz-picard"
      "mullvad-browser"
      "netnewswire"
      "obsidian"
      "omnidisksweeper"
      "plexamp"
      "retroarch-metal"
      "rocket"
      "transmit"
      "transnomino"
      "utm"
      "visual-studio-code"
      "vlc"
      "vmware-fusion"
      "xld"
      "zed"
      "font-fira-code"
      "font-monaspace"
      "font-jetbrains-mono"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Copilot: Track & Budget Money" = 1447330651;
      "Drafts" = 1435957248;
      "Front and Center" = 1493996622;
      "PCalc" = 403504866;
      "Tailscale" = 1475387142;
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "StopTheMadness Pro" = 6471380298;
      "Infuse • Video Player" = 1136220934;
      "The Unarchiver" = 425424353;
      "Windows App" = 1295203466;
    };
  };
}
