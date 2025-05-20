{
  pkgs,
  inputs,
  ...
}: let
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  imports = [
    ../../modules/darwin
  ];

  # Mini-specific configuration
  darwin.homebrew = {
    extraBrews = [
      "colima"
      "docker"
      "ffmpeg"
      "flac"
      "libdvdcss"
    ];

    extraCasks = [
      "balenaetcher"
      "calibre"
      "dolphin"
      "fission"
      "gzdoom"
      "handbrake"
      "ioquake3"
      "logi-options+"
      "makemkv"
      "musicbrainz-picard"
      "mullvad-browser"
      "parsec"
      "retroarch-metal"
      "thunderbird"
      "vmware-fusion"
      "xld"
    ];

    extraMasApps = {
      "The Unarchiver" = 425424353;
      "Windows App" = 1295203466;
    };
  };

  # Add any Mini-specific packages
  environment.systemPackages = with unstablePkgs; [
    yt-dlp
  ];
}
