{...}: {
  flake.homeModules.application-editor-vscode = {pkgs, ...}: {
    home.packages = with pkgs; [vscode];
    home.persistence."/persist".directories = [".vscode"];
  };
}
