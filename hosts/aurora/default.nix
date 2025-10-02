{pkgs, ...}: {
  imports = [
    ../../modules/darwin
  ];

  # Aurora-specific configuration can be added here
  darwin.homebrew = {
    # Any Aurora-specific brews, casks, or Mac App Store apps would go here
    extraBrews = [
      "ffmpeg"
    ];
    extraCasks = [
      "mullvad-browser"
      "parsec"
      "syncthing-app"
    ];
  };

  # Add any Aurora-specific packages
  environment.systemPackages = with pkgs; [
    unstable.yt-dlp
  ];
}
