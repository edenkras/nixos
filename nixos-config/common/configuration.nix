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
      libinput = {
        touchpad.naturalScrolling = true;
        mouse.naturalScrolling = false;
      };
    };
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };
#    pipewire = {
#      enable = true;
#      alsa.enable = true;
#      alsa.support32Bit = true;
#      pulse.enable = true;
#      jack.enable = true;
#    };
  };

  environment.systemPackages = with pkgs; [
    jq
    yq
    google-chrome
    networkmanagerapplet
    arandr
    discord
    haskellPackages.greenclip
    xclip
    nvimpager
    tldr

    # work
    slack
    kubectl
    kubectx
    k9s
    jetbrains.webstorm
    jetbrains.pycharm-professional
    jetbrains.datagrip
    jetbrains.idea-ultimate
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    sops
    zoom-us
  ];

  virtualisation.docker.enable = true;

  programs = {
    bash = {
      blesh.enable = true;
      shellAliases = {
        grep = "grep --color=auto";
        ls = "ls --color=auto";
        ll = "ls -la";
        k = "kubectl";
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
    fzf = {
      keybindings = true;
    };
    steam.enable = true;
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    fira-code-nerdfont
  ];

  systemd.user.services = {
    greenclip = {
      enable = true;
      description = "greenclip daemon";
      wantedBy = [ "default.target" ];
      startLimitIntervalSec = 0;
      serviceConfig = {
        ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon";
        Restart = "always";
      };
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  users.users.${identity.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };

  security = {
    rtkit.enable = true;
    sudo.extraRules = [
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
  };

  system.stateVersion = stateVersion;
}
