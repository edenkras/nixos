{ identity, config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [];

  programs = {
    neovim.enable = false;
  };
}
