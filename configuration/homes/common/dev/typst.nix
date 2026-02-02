{pkgs, ...}: {
  home.packages = with pkgs; [
    typst
    zathura
  ];
  home.persistence."/persist".directories = [
    ".cache/typst"
    ".local/share/typst"
  ];
}
