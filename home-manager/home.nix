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
      plugins = with pkgs; [
        rofi-systemd
        rofi-screenshot
        rofi-pulse-select
        rofi-power-menu
      ];
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
