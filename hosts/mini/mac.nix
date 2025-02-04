{

  system.defaults.finder = {
    # show full path in finder title
    _FXShowPosixPathInTitle = true;

    # show all file extensions
    AppleShowAllExtensions = true;

    # show hidden files
    AppleShowAllFiles = false;

    # disable warning when changing file extension
    FXEnableExtensionChangeWarning = false;

    # default finder view
    FXPreferredViewStyle = "Nlsv";

    # remove items in the trash after 30 days
    FXRemoveOldTrashItems = true;

    # default folder shown in Finder windows
    NewWindowTarget = "Home";

    # hide the quit button on finder
    QuitMenuItem = true;

    # show path bar
    ShowPathbar = true;

    # show status bar
    ShowStatusBar = true;

    # disable icons on the desktop
    CreateDesktop = false;

    ShowExternalHardDrivesOnDesktop = true;
    ShowHardDrivesOnDesktop = true;
    ShowMountedServersOnDesktop = true;
    ShowRemovableMediaOnDesktop = true;
    _FXSortFoldersFirst = true;

    # When performing a search, search the current folder by default
    FXDefaultSearchScope = "SCcf";
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
    "com.apple.SoftwareUpdate" = {
      AutomaticCheckEnabled = true;
      # Check for software updates daily, not just once per week
      ScheduleFrequency = 1;
      AutomaticDownload = 1;
      # Install System data files & security updates
      CriticalUpdateInstall = 1;
    };
  };
  
}