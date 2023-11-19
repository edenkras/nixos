{ pkgs }:

{
  gcloud-init = (pkgs.writeShellScriptBin "gcloud-init" (builtins.readFile ./gcloud-init.sh));
}