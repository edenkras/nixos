{ pkgs }:

[
  (pkgs.writeShellScriptBin "gcloud-init" (builtins.readFile ./gcloud-init.sh))
]