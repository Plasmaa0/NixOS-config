{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    # idk how tf make it use picom.conf as config in any way. 
    # with this solution it'll start it with DUPLICATE --config flag 
    # but thanks god picom will use the second one provided here
    extraArgs = [ "--config ${./picom.conf}"]; 
  };
}
