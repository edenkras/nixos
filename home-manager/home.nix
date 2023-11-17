# https://mipmip.github.io/home-manager-option-search/
{
  inputs,
  identity,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true; # https://github.com/nix-community/home-manager/issues/2942
    };
  };

  home = {
    username = identity.username;
    homeDirectory = "/home/${identity.username}";
    stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    file = {
      ".xinitrc".source = ./xinitrc;
    };
  };

  programs = {
    home-manager.enable = true;
    wezterm = {
      enable = true;
      enableBashIntegration = true;
    };
    rofi.enable = true;
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
