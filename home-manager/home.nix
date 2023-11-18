# https://mipmip.github.io/home-manager-option-search/
{
  inputs,
  identity,
  stateVersion,
  lib,
  config,
  pkgs,
  ...
}:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true; # https://github.com/nix-community/home-manager/issues/2942
    };
  };

  home = {
    username = identity.username;
    homeDirectory = "/home/${identity.username}";
    stateVersion = stateVersion;
    file = {
      ".xinitrc".source = ./xinitrc;
    };
    packages = with pkgs; [
      rofi-systemd
      rofi-screenshot
      rofi-pulse-select
      rofi-power-menu
    ];
    sessionVariables = {
      XDG_CONFIG_HOME="$HOME/.config";
      XDG_CACHE_HOME="$HOME/.cache";
      XDG_DATA_HOME="$HOME/.local/share";
      XDG_STATE_HOME="$HOME/.local/state";
      BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash-completion/bash_completion";
      XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority";
      XINITRC="$XDG_CONFIG_HOME/X11/xinitrc";
      XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc";
      PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass";
      NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history";
      _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
      PYENV_ROOT="$XDG_DATA_HOME/pyenv";
      CARGO_HOME="$XDG_DATA_HOME/cargo";
      RUSTUP_HOME="$XDG_DATA_HOME/rustup";
      DOCKER_CONFIG="$XDG_CONFIG_HOME/docker";
      GRADLE_USER_HOME="$XDG_DATA_HOME/gradle";
      GOPATH="$XDG_DATA_HOME/go";
      GOMODCACHE="$XDG_CACHE_HOME/go/mod";
      CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv";
      K9SCONFIG="$XDG_CONFIG_HOME/k9s";
    };
  };

  programs = {
    home-manager.enable = true;
    wezterm = {
      enable = true;
      enableBashIntegration = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
    rofi = {
      enable = true;
      theme = "Arc-Dark";
      font = "Fira Code 14";
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
  };

  xdg.configFile = {
    awesome = {
      source = ./awesome;
      recursive = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
