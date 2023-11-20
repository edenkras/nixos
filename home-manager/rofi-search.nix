pkgs:

let
  rofi-search = (
    pkgs.writeScript "rofi-search" (
      builtins.readFile (
        pkgs.fetchFromGitHub {
          owner = "fogine";
          repo = "rofi-search";
          rev = "1.1.0";
          sha256 = "sha256-oGo6aJOdxxRmIeOI5Z6Ls4WyOsUEXFoCYaWeDpjW14g=";
        } + "/rofi-search"
      )
    )
  ).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
in pkgs.symlinkJoin rec {
  name = "rofi-search";
  paths = [ rofi-search pkgs.nodejs_21 ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${name} --set PATH : $out/bin";
}
