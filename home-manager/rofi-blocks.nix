pkgs:

let
  pname = "rofi-blocks";
in pkgs.stdenv.mkDerivation {
  name = pname;
  src = pkgs.fetchFromGitHub {
    owner = "OmarCastro";
    repo = "rofi-blocks";
    rev = "0a2ba561aa9a31586c0bc8203f8836a18a1f664e";
    sha256 = "sha256-U955hzd55xiV5XdQ18iUIwNLn2JrvuHsItgUSf6ww58=";
  };
  buildInputs = with pkgs; [ autoconf automake libtool pkg-config json-glib cairo rofi ];
  buildPhase = ''
    autoreconf -i
    mkdir build
    cd build/
    chmod +x $out
    ../configure
    make
    make install
  '';
  installPhase = ''
    mkdir -p $out/bin
  '';
}