{ pkgs, lib, config, ... }: {

  options = {
    packages.enable = lib.mkEnableOption "enables packages";
  };

  config = lib.mkIf config.packages.enable {

    home.packages = with pkgs; [
      coreutils
      deadnix
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
      gnumake
      jq
      just
      keychain
      mc
      mosh
      nil
      nixpkgs-fmt
      nmap
      parallel
      pre-commit
      ripgrep
      shellcheck
      statix
      sqlite
      unzip
    ];

  };

}
