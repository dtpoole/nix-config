{ config, pkgs, unstablePkgs, system, username, agenix, ... }:
{

  nixpkgs.hostPlatform = system;

  users.users.${username}.home = "/Users/${username}";

  nix = {
    #package = lib.mkDefault pkgs.unstable.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  nixpkgs.config.allowUnfree = true;

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
    terraform
    rnix-lsp
    agenix.packages.${system}.default
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
    onActivation.upgrade = true;

    casks = [
      "1password"
      "balenaetcher"
      "bartender"
      "calibre"
      "fission"
      "handbrake"
      "launchbar"
      "musicbrainz-picard"
      "netnewswire"
      "obsidian"
      "omnidisksweeper"
      "plexamp"
      "thunderbird"
      "visual-studio-code"
      "vlc"
      "vmware-fusion"
      "xld"
      "font-fira-code"
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
    };
  };

  # age.secrets.test.file = ../../secrets/test.age;

  # environment.etc = {
  #   testrc = {
  #     copy = true; # symlink doesn't seem to work
  #     source = config.age.secrets.test.path;
  #   };
  # };

}
