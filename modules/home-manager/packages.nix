{
  pkgs,
  lib,
  config,
  ...
}: let
  allPackages = with pkgs; {
    base = [dua dust duf eza fd ripgrep tldr unixtools.column unzip zip];
    development = [direnv jq nil parallel pre-commit sqlite];
    system = [dig nmap procs];
    misc = [figurine magic-wormhole mc];
  };
in {
  options = {
    packages.enable = lib.mkEnableOption "enables packages";
    packages.sets =
      lib.genAttrs
      ["base" "development" "system" "misc"]
      (name:
        lib.mkEnableOption "${name} package set"
        // {
          default = name == "base";
        });
  };

  config = lib.mkIf config.packages.enable {
    home.packages = lib.concatLists (
      lib.mapAttrsToList
      (name: pkgs: lib.optionals config.packages.sets.${name} pkgs)
      allPackages
    );
  };
}
