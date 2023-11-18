# https://mipmip.github.io/home-manager-option-search/
{
  inputs,
  extraArgs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (extraArgs) identity stateVersion;
in {
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
  };

  programs = {
    home-manager.enable = true;
    wezterm = {
      enable = true;
      enableBashIntegration = true;
      extraConfig = ''
        hide_tab_bar_if_only_one_tab = true
      '';
    };
    rofi = {
      enable = true;
      theme = "Arc-Dark";
    };
    k9s.enable = false;
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
