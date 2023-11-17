{ identity, config, pkgs, ... }:
let
  awesome = pkgs.awesome.overrideAttrs (old: rec {
    version = "5daae2bb5d90117eb341ad72eb123c4e6804b780";
    src = prev.fetchFromGitHub {
      owner = "awesomewm";
      repo = "awesome";
      rev = version;
      sha256 = "sha256-o69if8HQw2u0fp5J7jkS4WQeAXVuiFwpDLzGFscP4mM=";
    };
    patches = [];
    postPatch = ''
      patchShebangs tests/examples/_postprocess.lua
    '';
  });
in {
  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.device = "/dev/nvme0n1";
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

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
      xkbOptions = "eurosign:e,caps:escape";
      windowManager.awesome = {
        enable = true;
        package = awesome;
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
    slack
    kubectl
    jetbrains-toolbox
    google-cloud-sdk
    docker
  ];

  programs = {
    bash = {
      blesh.enable = true;
      shellAliases = {
        grep = "grep --color=auto";
        ls = "ls --color=auto";
        ll = "ls -la";
      };
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
#      config = {
#        userName = identity.username;
#        userEmail = identity.email;
#      };
    };
    fzf = {
      keybindings = true;
    };
    nm-applet.enable = true;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.${identity.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "23.05";
}
