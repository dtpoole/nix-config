{pkgs}: {
  default = pkgs.mkShellNoCC {
    nativeBuildInputs = with pkgs; [
      alejandra
      deadnix
      git
      home-manager
      just
      nh
      nix-output-monitor
      nix-tree
      nvd
      statix
    ];

    shellHook = ''
      ${pkgs.figurine}/bin/figurine -f 'JS Block Letters.flf' nix
      echo && just --list && echo
      PS1='[nix] \W \$ '
    '';
  };
}
