pkgs:

let
  pname = "rofi-search";
  rofi-search = (
    pkgs.writeScriptBin pname (
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
in pkgs.symlinkJoin {
  name = pname;
  paths = [ rofi-search pkgs.nodejs_21 pkgs.ddgr ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${pname} --set PATH $out/bin";
}
