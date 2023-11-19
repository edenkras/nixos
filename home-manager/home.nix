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
let
  homeDirectory = "/home/${identity.username}";
  xdg = {
    configHome = "${homeDirectory}/.config";
    cacheHome = "${homeDirectory}/.cache";
    dataHome = "${homeDirectory}/.local/share";
    stateHome = "${homeDirectory}/.local/state";
  };
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true; # https://github.com/nix-community/home-manager/issues/2942
    };
  };

  home = rec {
    inherit stateVersion homeDirectory;
    username = identity.username;
    file = {
      ".xinitrc".source = ./xinitrc;
      ".icons/default".source = "${pkgs.quintom-cursor-theme}/share/icons/Quintom_Ink";
    };
    packages = with pkgs; [
      rofi-systemd
      rofi-screenshot
      rofi-pulse-select
      rofi-power-menu
    ];
    sessionVariables = {
      PASSWORD_STORE_DIR="${xdg.dataHome}/pass";
      NODE_REPL_HISTORY="${xdg.dataHome}/node_repl_history";
      _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${xdg.configHome}/java";
      PYENV_ROOT="${xdg.dataHome}/pyenv";
      CARGO_HOME="${xdg.dataHome}/cargo";
      RUSTUP_HOME="${xdg.dataHome}/rustup";
      DOCKER_CONFIG="${xdg.configHome}/docker";
      GRADLE_USER_HOME="${xdg.dataHome}/gradle";
      GOPATH="${xdg.dataHome}/go";
      GOMODCACHE="${xdg.cacheHome}/go/mod";
      CUDA_CACHE_PATH="${xdg.cacheHome}/nv";
      K9SCONFIG="${xdg.configHome}/k9s";
    };
  };

  programs = {
    bash.enable = true;
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

  systemd.user.startServices = "sd-switch"; # Nicely reload system units when changing configs
}
