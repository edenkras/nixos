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
  paths = with pkgs; [ rofi-search nodejs_21 ddgr ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    mkdir $out/.bin;
    mv $out/bin/* $out/.bin;
    makeWrapper $out/.bin/${pname} $out/bin/${pname} --set PATH $out/.bin
  '';
}
