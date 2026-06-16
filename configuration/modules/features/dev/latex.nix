{...}: {
  flake.homeModules.dev-latex = {pkgs, ...}: {
    home.packages = with pkgs; [
      texlive.combined.scheme-basic
      zathura
    ];
  };
}
