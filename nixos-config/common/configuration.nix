{ identity, stateVersion, config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.device = "/dev/nvme0n1";
  };

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "${identity.username}-${identity.host}";
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Jerusalem";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      layout = "us,il";
      xkb.options = "grp:win_space_toggle";
      windowManager.awesome = {
        enable = true;
        package = import ./awesome-git.nix pkgs;
      };
    };
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };
  };

  environment.systemPackages = with pkgs; [
    jq
    yq
    google-chrome
    docker
    networkmanagerapplet

    # work
    slack
    kubectl
    jetbrains-toolbox
    google-cloud-sdk
  ];

  programs = {
    bash = {
      blesh.enable = true;
      shellAliases = {
        grep = "grep --color=auto";
        ls = "ls --color=auto";
        ll = "ls -la";
      };
      loginShellInit = ''
        [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
      '';
    };
    neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      defaultEditor = true;
    };
    git = {
      enable = true;
      lfs.enable = true;
      config = {
        user = {
          name = identity.username;
          email = identity.email;
        };
      };
    };
    fzf = {
      keybindings = true;
    };
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.${identity.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo.extraRules = [
    {
      users = [ identity.username ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  system.stateVersion = stateVersion;
}
