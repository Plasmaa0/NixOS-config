{...}: {
  flake.homeModules.applications = {...}: {
    programs.mangohud = {
      enable = true;
    };
  };
}
