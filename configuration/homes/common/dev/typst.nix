{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    typst
    zathura
  ];
  home.persistence."/persist/home/${config.home.username}".directories = [
    ".cache/typst"
  ];
}
