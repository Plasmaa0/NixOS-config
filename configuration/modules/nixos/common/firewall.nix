{...}: {
  flake.nixosModules.firewall = {lib, ...}: {
    networking.firewall = let
      inherit (lib) range;
      mindustry = [6567];
      minecraft = [25565];
      steam-voicechat = range 27014 27020;
      kde-connect = range 1714 1764;
      printing = [631];
      ports =
        [8080 8000]
        ++ mindustry
        ++ minecraft
        ++ steam-voicechat
        ++ kde-connect
        ++ printing;
    in {
      enable = true;
      allowedTCPPorts = ports;
      allowedUDPPorts = ports;
    };
  };
}
