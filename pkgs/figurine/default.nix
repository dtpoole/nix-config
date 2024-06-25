{ lib, pkgs }:

let
  name = "figurine";
  version = "1.3.0";
in

pkgs.buildGoModule {
  inherit name;
  src = pkgs.fetchFromGitHub {
    owner = "arsham";
    repo = name;
    rev = "v${version}";
    sha256 = "1q6Y7oEntd823nWosMcKXi6c3iWsBTxPnSH4tR6+XYs=";
  };

  vendorHash = "sha256-mLdAaYkQH2RHcZft27rDW1AoFCWKiUZhh2F0DpqZELw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    #  "-X main.currentSha=${src.rev}"
  ];


  meta = with lib; {
    homepage = "https://github.com/arsham/figurine";
    description = "Print your name in style";
    license = licenses.asl20;
  };
}
