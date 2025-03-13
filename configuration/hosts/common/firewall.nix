{...}: {
  networking.firewall = let
    ports = [
      6567 #mindustry localhost
      25565 #minecraft
    ];
  in {
    enable = true;
    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };
}
