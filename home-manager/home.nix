# https://mipmip.github.io/home-manager-option-search/
{
  identity,
  stateVersion,
  lib,
  config,
  pkgs,
  ...
}:
let
  homeDirectory = "/home/${identity.username}";
  sessionVariables = import ./session-variables.nix homeDirectory;
  gitConfigFile = "git/gitconfig";
  gitWorkConfigFile = "git/gitconfig.work";
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true; # https://github.com/nix-community/home-manager/issues/2942
    };
  };

  home = {
    inherit stateVersion homeDirectory sessionVariables;
    username = identity.username;
    file = {
      ".xinitrc".source = ./xinitrc;
      ".icons/default".source = "${pkgs.quintom-cursor-theme}/share/icons/Quintom_Ink";
    };
    packages = with pkgs; [
      rofi-systemd
      rofi-power-menu
      rofi-screenshot
      (import ./rofi/rofi-search.nix pkgs)
    ] ++ import ./scripts pkgs;
  };

  programs = {
    bash.enable = true;
    home-manager.enable = true;
    wezterm = {
      enable = true;
      enableBashIntegration = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
    git = {
      enable = true;
      lfs.enable = true;
      extraConfig = {
        user.name = identity.username;
        diff.tool = "nvimdiff";
        merge.tool = "nvimdiff";
        "includeIf \"gitdir:${sessionVariables.WORK_DIR}/**\"".path = "${homeDirectory}/.config/${gitWorkConfigFile}";
        "includeIf \"gitdir:${sessionVariables.PERSONAL_DIR}/**\"".path = "${homeDirectory}/.config/${gitConfigFile}";
      };
    };
    ssh = {
      enable = true;
      extraConfig = ''
        Host code.zeekit.walmart.com
          ProxyCommand gcloud --configuration=zeekit-common compute start-iap-tunnel gitlab %p  --zone=us-central1-a --listen-on-stdin --verbosity=warning

        Host *
          SetEnv TERM=xterm-256color
      '';
    };
    rofi = {
      enable = true;
      theme = "Arc-Dark";
      font = "Fira Code 14";
      extraConfig = {
         modes = "power:rofi-power-menu,clipboard:greenclip print";
         ssh-command = "{terminal} {ssh-client} {host} [-p {port}]";
      };
      pass.enable = true;
      plugins = with pkgs; [
        rofi-top
        (import ./rofi/rofi-blocks pkgs)
      ];
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${homeDirectory}/.local/share/pass";
      };
    };
    thefuck = {
      enable = true;
      enableInstantMode = true;
    };
  };

  xdg.configFile = {
    awesome = {
      source = ./awesome;
      recursive = true;
    };
    "${gitWorkConfigFile}".text = ''
      [user]
        email = ${identity.workEmail}
    '';
    "${gitConfigFile}".text = ''
      [user]
        email = ${identity.email}
    '';
  };

  systemd.user.startServices = "sd-switch"; # Nicely reload system units when changing configs
}
