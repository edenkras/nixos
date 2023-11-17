{ identity, config, pkgs, ... }:

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
      xkbOptions = "eurosign:e,caps:escape";
      windowManager.awesome = {
        enable = true;
        luaModules = [ pkgs.luaPackages.lgi ];
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
    steam
    discord
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
