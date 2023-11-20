pkgs:

pkgs.writeShellScriptBin "rofi-search" (builtins.readFile (
  fetchFromGitHub {
    owner = "fogine";
    repo = "rofi-search";
    rev = "1.1.0";
    sha256 = "";
  } + "/rofi-search"
))