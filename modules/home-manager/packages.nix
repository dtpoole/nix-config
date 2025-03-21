{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    packages.enable = lib.mkEnableOption "enables packages";
  };

  config = lib.mkIf config.packages.enable {
    home.packages = with pkgs; [
      coreutils
      dig
      direnv
      dua
      duf
      du-dust
      eza
      fd
      figurine
      file
      gitui
      jq
      mc
      nmap
      parallel
      pre-commit
      ripgrep
      shellcheck
      sqlite
      unzip
      unixtools.column
    ];
  };
}
