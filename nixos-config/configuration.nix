{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.device = "/dev/nvme0n1";
  };

  networking = {
    hostName = "eden-laptop";
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
      windowManager.awesome.enable = true;
    };
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.eden = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "23.05";
}
