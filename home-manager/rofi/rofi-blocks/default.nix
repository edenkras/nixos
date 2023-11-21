pkgs:

pkgs.stdenv.mkDerivation {
  name = "rofi-blocks";
  src = pkgs.fetchFromGitHub {
    owner = "OmarCastro";
    repo = "rofi-blocks";
    rev = "0a2ba561aa9a31586c0bc8203f8836a18a1f664e";
    sha256 = "sha256-U955hzd55xiV5XdQ18iUIwNLn2JrvuHsItgUSf6ww58=";
  };
  nativeBuildInputs = with pkgs; [
    autoreconfHook
    pkg-config
    cairo
    rofi-unwrapped
    json-glib
  ];
#  buildInputs = with pkgs; [
#    rofi-unwrapped
#    json-glib
#  ];
  patches = [ ./patch ];
}