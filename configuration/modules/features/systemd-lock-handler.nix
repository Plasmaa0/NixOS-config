{...}: {
  flake.nixosModules.systemd-lock-handler = {...}: {
    services.systemd-lock-handler.enable = true;
  };
}
