pkgs:

pkgs.awesome.overrideAttrs (old: rec {
  version = "5daae2bb5d90117eb341ad72eb123c4e6804b780";
  src = pkgs.fetchFromGitHub {
    owner = "awesomewm";
    repo = "awesome";
    rev = version;
    sha256 = "sha256-o69if8HQw2u0fp5J7jkS4WQeAXVuiFwpDLzGFscP4mM=";
  };
  patches = [];
  postPatch = "patchShebangs tests/examples/_postprocess.lua";
})