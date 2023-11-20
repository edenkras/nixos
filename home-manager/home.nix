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
      haskellPackages.greenclip
    ] ++ import ./scripts pkgs;
    sessionVariables = import ./sessionVariables.nix homeDirectory;
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

  systemd.user = {
    startServices = "sd-switch"; # Nicely reload system units when changing configs
    services.greenclip = {
      Unit.Description = "greenclip daemon";
      Unit.After = [ "multi-user.target" ];
      Install.WantedBy = [ "multi-user.target" ];
      Service.ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon";
    };
  };
}
