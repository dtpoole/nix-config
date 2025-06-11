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
      magic-wormhole
      mc
      nil
      nmap
      parallel
      pre-commit
      procs
      ripgrep
      sqlite
      unzip
      unixtools.column
    ];
  };
}
