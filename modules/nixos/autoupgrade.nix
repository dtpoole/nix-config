{
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    autoupgrade.enable = lib.mkEnableOption "enables autoupgrade module";
  };

  config = lib.mkIf config.autoupgrade.enable {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L" # print build logs
      ];
      dates = "weekly";
      randomizedDelaySec = "45min";
    };
  };
}
