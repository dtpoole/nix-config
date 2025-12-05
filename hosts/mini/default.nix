{pkgs, ...}: {
  imports = [
    ../../modules/darwin
  ];

  # Mini-specific configuration
  darwin.homebrew = {
    extraBrews = [
      "flac"
      "libdvdcss"
    ];

    extraCasks = [
      "balenaetcher"
      "calibre"
      "dolphin"
      "fission"
      "gzdoom"
      "handbrake-app"
      "ioquake3"
      "llamabarn"
      "logi-options+"
      "musicbrainz-picard"
      "mullvad-browser"
      "retroarch-metal"
      "syncthing-app"
      "thunderbird"
      "vmware-fusion"
      "xld"
    ];

  };

  # Add any Mini-specific packages
  environment.systemPackages = with pkgs; [
    unstable.yt-dlp
  ];
}
