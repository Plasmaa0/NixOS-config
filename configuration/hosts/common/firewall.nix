{...}: {
  networking.firewall = let
    ports = [
      6567 #mindustry localhost
      25565 #minecraft
      8080
      8000
    ];
  in {
    enable = true;
    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };
}
