{...}: {
  networking.firewall = let
    ports = [
      6567 #mindustry localhost
      25565 #minecraft
      8080
      8000
      # steam voicechat
      27014
      27015
      27016
      27017
      27018
      27019
      27020
    ];
  in {
    enable = true;
    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };
}
