{pkgs, ...}: {
  home.packages = with pkgs; [vscode];
  home.persistence."/persist".directories = [".vscode"];
}
