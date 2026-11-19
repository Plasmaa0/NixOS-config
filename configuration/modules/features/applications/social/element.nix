{...}: {
  flake.homeModules.application-social-element = {...}: {
    programs.element-desktop.enable = true;
    home.persistence."/persist".directories = [".config/Element"];
  };
}
