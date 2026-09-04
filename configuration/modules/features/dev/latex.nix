{...}: {
  flake.homeModules.dev-latex = {pkgs, ...}: {
    home.packages = with pkgs; [
      texliveFull
      zathura
    ];
  };
}
