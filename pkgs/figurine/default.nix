{ stdenv, pkgs }:

stdenv.mkDerivation {
  pname = "figurine";
  version = "1.3.0";
  src = pkgs.buildGoModule {
    name = "figurine";
    src = pkgs.fetchFromGitHub {
      owner = "arsham";
      repo = "figurine";
      rev = "v${version}";
      sha256 = "1q6Y7oEntd823nWosMcKXi6c3iWsBTxPnSH4tR6+XYs=";
    };
    vendorSha256 = "mLdAaYkQH2RHcZft27rDW1AoFCWKiUZhh2F0DpqZELw=";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/arsham/figurine";
    description = "Print your name in style";
    license = licenses.asl20;
  };

}
