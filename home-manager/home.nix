# https://mipmip.github.io/home-manager-option-search/
{
  inputs,
  identity,
  stateVersion,
  lib,
  config,
  pkgs,
  stdenv,
  ...
}:
let
  homeDirectory = "/home/${identity.username}";
  rofi-blocks = import ./rofi-blocks.nix { inherit stdenv pkgs; };
  rofi-search = import ./rofi-search.nix pkgs;
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
      rofi-power-menu
      rofi-blocks
      rofi-search
    ] ++ import ./scripts pkgs;
    sessionVariables = import ./session-variables.nix homeDirectory;
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
      font = "Fira Code 16";
      extraConfig = {
         modes = "power:rofi-power-menu,clipboard:greenclip print";
         ssh-command = "{terminal} {ssh-client} {host} [-p {port}]";
      };
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
