{pkgs, ...}: {
  imports = [
    ../../modules/darwin
  ];

  # Aurora-specific configuration can be added here
  darwin.homebrew = {
    # Any Aurora-specific brews, casks, or Mac App Store apps would go here

    extraCasks = [
      "mullvad-browser"
      "syncthing-app"
    ];
  };

  # Add any Aurora-specific packages
  environment.systemPackages = with pkgs; [
    unstable.yt-dlp
  ];
}
