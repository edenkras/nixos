pkgs:

let
  pname = "rofi-blocks";
  fake-rofi = pkgs.rofi-unwrapped.overrideAttrs (old: {
    installPhase = ''
      sed -i 's@$${libdir}/rofi@$${ROFI_PLUGINS_PATH}@g' $out/lib/pkgconfig/rofi.pc
    '';
  });
in pkgs.stdenv.mkDerivation {
  name = pname;
  src = pkgs.fetchFromGitHub {
    owner = "OmarCastro";
    repo = "rofi-blocks";
    rev = "0a2ba561aa9a31586c0bc8203f8836a18a1f664e";
    sha256 = "sha256-U955hzd55xiV5XdQ18iUIwNLn2JrvuHsItgUSf6ww58=";
  };
  buildInputs = with pkgs; [ autoconf automake libtool pkg-config json-glib cairo fake-rofi ];
  installPhase = ''
    mkdir -p "$(pkg-config --variable=pluginsdir rofi)"
  '';
#  buildPhase = ''
#    autoreconf -i
#    mkdir build
#    cd build/
#    ../configure
#    make
#    make install
#  '';
#  installPhase = ''
#    mkdir -p $out/bin
#  '';
}