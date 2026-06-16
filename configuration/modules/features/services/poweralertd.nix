{...}: {
  flake.homeModules.service-poweralertd = {...}: {
    services.poweralertd.enable = true; # notifications about "power"-related things
  };
}
