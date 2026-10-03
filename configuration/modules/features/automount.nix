{...}: {
  flake.nixosModules.automount = {...}: {
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    # removable-media mounting: Noctalia's aristides/udiskie plugin (modules/features/desktop/noctalia.nix)
  };
}
