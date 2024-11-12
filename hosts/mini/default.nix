{
  pkgs,
  inputs,
  ...
}: let
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  username = "dave";
in {
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;

  imports = [
    inputs.agenix.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = import ../../modules/home-manager/desktop.nix;
        extraSpecialArgs = {inherit username;};
      };
    }
  ];

  users.users.${username}.home = "/Users/${username}";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;

  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  #services.nix-daemon.package = pkgs.nixFlakes;

  # if you use zsh (the default on new macOS installations),
  # you'll need to enable this so nix-darwin creates a zshrc sourcing needed environment changes
  programs.zsh.enable = true;

  environment.shells = [pkgs.zsh];
  environment.systemPackages = [
    unstablePkgs.yt-dlp
    inputs.agenix.packages.${pkgs.system}.default
    pkgs.nixd
  ];

  # for nixd
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  system.defaults.finder = {
    # show full path in finder title
    _FXShowPosixPathInTitle = true;

    # remove items from trash after 30 days
    # FXRemoveOldTrashItems = true;

    # show all file extensions
    AppleShowAllExtensions = true;

    # show hidden files
    AppleShowAllFiles = true;

    # disable warning when changing file extension
    FXEnableExtensionChangeWarning = false;

    # hide the quit button on finder
    QuitMenuItem = true;

    # show path bar
    ShowPathbar = true;

    # show status bar
    ShowStatusBar = true;

    # disable icons on the desktop
    CreateDesktop = false;
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.desktopservices" = {
      # Avoid creating .DS_Store files on network or USB volumes
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
    "com.apple.dock" = {
      autohide = true;
      magnification = 0;
      show-recents = false;
      show-process-indicators = true;
      orientation = "left";
      tilesize = 38;
    };

    "com.apple.finder" = {
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      _FXSortFoldersFirst = true;

      # When performing a search, search the current folder by default
      FXDefaultSearchScope = "SCcf";
    };

    "com.apple.SoftwareUpdate" = {
      AutomaticCheckEnabled = true;
      # Check for software updates daily, not just once per week
      ScheduleFrequency = 1;
      AutomaticDownload = 1;
      # Install System data files & security updates
      CriticalUpdateInstall = 1;
    };
  };

  homebrew = {
    enable = true;

    onActivation = {
      # upgrade = true;
      autoUpdate = true;
      # cleanup = "zap";
    };

    brews = [
      "colima"
      "docker"
      "libdvdcss"
      "mas"
      "terraform"
    ];

    casks = [
      "1password"
      "balenaetcher"
      "calibre"
      "fission"
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
      "steam"
      "transnomino"
      "visual-studio-code"
      "vlc"
      "vmware-fusion"
      "xld"
      "zed"
      "font-fira-code"
      "font-monaspace"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Copilot: Track & Budget Money" = 1447330651;
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
