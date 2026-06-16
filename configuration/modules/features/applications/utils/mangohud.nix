{...}: {
  flake.homeModules.application-utils-mangohud = {...}: {
    programs.mangohud = {
      enable = true;
    };
  };
}
