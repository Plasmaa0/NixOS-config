{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [vscode];
  home.persistence."/persist/home/${config.home.username}".directories = [".vscode"];
}
