{ pkgs, inputs, outputs, ... }:

let
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{

  nixpkgs.hostPlatform = "x86_64-darwin";

  imports =
    [
      inputs.agenix.darwinModules.default
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dave = import ../../home/dave/desktop.nix;
          extraSpecialArgs = { inherit outputs; };
        };
      }
    ];


  users.users.dave.home = "/Users/dave";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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

  environment.systemPackages = with pkgs; [
    unstablePkgs.yt-dlp
    ansible
    ansible-lint
    sshpass
    terraform
    inputs.agenix.packages.${pkgs.system}.default
  ];

  # fonts.fonts = with pkgs; [
  #   cascadia-code
  #   fira-code
  #   fira-code-symbols
  #   # gelasio
  #   jetbrains-mono
  #   #nerdfonts
  #   meslo-lg
  #   # powerline-fonts
  #   source-code-pro
  #   # ttf_bitstream_vera
  #   # ubuntu_font_family
  # ];

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
      #upgrade = true;
      autoUpdate = true;
    };

    brews = [
      "libdvdcss"
    ];

    casks = [
      "1password"
      "balenaetcher"
      "bartender"
      "calibre"
      "fission"
      "handbrake"
      "adoptopenjdk"
      "itsycal"
      "kitty"
      "launchbar"
      "makemkv"
      "musicbrainz-picard"
      "netnewswire"
      "obsidian"
      "omnidisksweeper"
      "plexamp"
      "steam"
      "thunderbird"
      "transnomino"
      "visual-studio-code"
      "vlc"
      "vmware-fusion"
      "xld"
      "font-fira-code"
      "font-monaspace"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Front and Center" = 1493996622;
      "Microsoft Remote Desktop" = 1295203466;
      "PCalc" = 403504866;
      "Tailscale" = 1475387142;
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "StopTheMadness" = 1376402589;
      "Bitwarden" = 1352778147;
      "Infuse • Video Player" = 1136220934;
      "The Unarchiver" = 425424353;
    };

    # taps = [
    #   "hashicorp/tap"
    # ];

  };

}
