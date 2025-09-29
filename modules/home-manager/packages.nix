{
  pkgs,
  lib,
  config,
  ...
}: let
  packageSets = {
    # Essential command-line utilities
    base = with pkgs; [
      dua # Disk usage analyzer
      du-dust # Intuitive du
      duf # Disk usage/free utility
      eza # Modern ls replacement
      fd # Fast find alternative
      ripgrep # Fast grep alternative
      tldr # Simplified man pages
      unixtools.column
      unzip
      zip
    ];

    # Development tools
    development = with pkgs; [
      direnv # Environment switcher
      gitui # Terminal UI for git
      jq # JSON processor
      nil # Nix language server
      parallel # Parallel execution
      pre-commit # Git pre-commit framework
      sqlite # Database
    ];

    # System and network utilities
    system = with pkgs; [
      dig # DNS lookup
      nmap # Network scanner
      procs # Modern ps replacement
    ];

    # Miscellaneous utilities
    misc = with pkgs; [
      figurine # ASCII art generator
      magic-wormhole # Secure file transfer
      mc # Midnight Commander
    ];
  };
in {
  options = {
    packages = {
      enable = lib.mkEnableOption "enables packages";

      sets = {
        base = lib.mkEnableOption "base utilities" // {default = true;};
        development = lib.mkEnableOption "development tools" // {default = false;};
        system = lib.mkEnableOption "system utilities" // {default = false;};
        misc = lib.mkEnableOption "miscellaneous utilities" // {default = false;};
      };
    };
  };

  config = lib.mkIf config.packages.enable {
    home.packages = lib.flatten [
      (lib.optional config.packages.sets.base packageSets.base)
      (lib.optional config.packages.sets.development packageSets.development)
      (lib.optional config.packages.sets.system packageSets.system)
      (lib.optional config.packages.sets.misc packageSets.misc)
    ];
  };
}
