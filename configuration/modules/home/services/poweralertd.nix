{...}: {
  flake.homeModules.services = {...}: {
    services.poweralertd.enable = true; # notifications about "power"-related things
  };
}
