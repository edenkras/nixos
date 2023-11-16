# https://mipmip.github.io/home-manager-option-search/
{
  inputs,
  username,
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
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true; # https://github.com/nix-community/home-manager/issues/2942
    };
  };

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    packages = with pkgs; [
      steam
      discord
    ];
  };

  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      shellAliases = {
        grep = "grep --color=auto";
        ls = "ls --color=auto";
        ll = "ls -la";
      };
    };
    git = {
      enable = true;
      userName = username;
      userEmail = "edenkras@gmail.com";
    };
    neovim.enable = true;
    wezterm.enable = true;
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    jq.enable = true;
    rofi.enable = true;
    k9s.enable = false;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
