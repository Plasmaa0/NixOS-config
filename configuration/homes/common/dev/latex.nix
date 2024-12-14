{pkgs, ...}: {
  home.packages = with pkgs; [
    texlive.combined.scheme-full
    tectonic
    zathura
  ];
}
