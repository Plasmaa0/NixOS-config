{ config, pkgs, ... }:

{
  home.file."${config.xdg.configHome}/picom" = {
    source = ./../dotfiles/picom;
    recursive = true;
  };
  services.picom = {
    enable = true;
    # idk how tf make it use picom.conf as config in any way. 
    # with this solution it'll start it with DUPLICATE --config flag 
    # but thanks god picom will use the second one provided here
    extraArgs = [ "--config ${config.xdg.configHome}/picom/picom.conf"]; 
  };
}
