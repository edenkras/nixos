pkgs:

let
  pname = "rofi-blocks";
in pkgs.stdenv.mkDerivation {
  name = pname;
  src = pkgs.fetchFromGitHub {
    owner = "OmarCastro";
    repo = "rofi-blocks";
    rev = "0a2ba561aa9a31586c0bc8203f8836a18a1f664e";
    sha256 = "";
  };
}