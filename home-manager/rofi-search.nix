pkgs:

pkgs.writeShellScriptBin "rofi-search" (builtins.readFile (
  pkgs.fetchFromGitHub {
    owner = "fogine";
    repo = "rofi-search";
    rev = "1.1.0";
    sha256 = "sha256-oGo6aJOdxxRmIeOI5Z6Ls4WyOsUEXFoCYaWeDpjW14g=";
  } + "/rofi-search"
))