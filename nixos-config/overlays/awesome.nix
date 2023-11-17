final: perv: {
  awesome-git = prev.awesome.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "awesomeWM";
      repo = "awesome";
      rev = "7ed4dd620bc73ba87a1f88e6f126aed348f94458";
      sha256 = "";
    };
  });
}