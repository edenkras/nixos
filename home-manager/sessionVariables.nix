homeDir:

let
  configHome = "${homeDir}/.config";
  cacheHome = "${homeDir}/.cache";
  dataHome = "${homeDir}/.local/share";
  stateHome = "${homeDir}/.local/state";
in {
  WORK_DIR="${homeDir}/walmart";
  PASSWORD_STORE_DIR="${dataHome}/pass";
  NODE_REPL_HISTORY="${dataHome}/node_repl_history";
  _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${configHome}/java";
  PYENV_ROOT="${dataHome}/pyenv";
  CARGO_HOME="${dataHome}/cargo";
  RUSTUP_HOME="${dataHome}/rustup";
  DOCKER_CONFIG="${configHome}/docker";
  GRADLE_USER_HOME="${dataHome}/gradle";
  GOPATH="${dataHome}/go";
  GOMODCACHE="${cacheHome}/go/mod";
  CUDA_CACHE_PATH="${cacheHome}/nv";
  K9SCONFIG="${configHome}/k9s";
}