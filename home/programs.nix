{ pkgs, ... }:

let
  gnuls = pkgs.runCommand "gnuls" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.coreutils}/bin/ls $out/bin/ls
  '';
in
{

  home.packages = with pkgs; [
    gnuls
    direnv
    figlet
    fd
    gnumake
    jq
    keychain
    mosh
    nixpkgs-fmt
    nmap
    parallel
    ripgrep
    shellcheck
    sqlite
    tmux
    tree
    vivid
  ];
}
