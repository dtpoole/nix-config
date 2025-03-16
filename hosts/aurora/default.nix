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

  # Aurora-specific configuration can be added here
  darwin.homebrew = {
    # Any Aurora-specific brews, casks, or Mac App Store apps would go here
  };

  # Add any Aurora-specific packages
  environment.systemPackages = with unstablePkgs; [
    yt-dlp
  ];
}
