{ identity, config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [];

  programs = {};

#  services = {
#    autorandr = {
#      enable = true;
#    };
#    acpid = {
#      enable = true;
#      lidEventCommands = ''
#        export DISPLAY=:0
#        export XAUTHORITY=/run/user/1000/Xauthority
#        case "$3" in
#            close)
#                if [ "$(${pkgs.autorandr}/bin/autorandr --current)" != "standalone" ];then
#                        ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --off
#                        systemctl start --no-block autorandr.service
#                fi
#                ;;
#            open)
#                if [ "$(${pkgs.autorandr}/bin/autorandr --current)" != "standalone" ];then
#                        ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --auto
#                        systemctl start --no-block autorandr.service
#                fi
#                ;;
#            *)
#                ;;
#      '';
#    };
#  };
}
