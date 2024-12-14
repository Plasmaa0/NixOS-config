{
  config,
  pkgs,
  ...
}: {
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    terminal.shell = {
      args = ["--login"];
      program = "fish";
    };
    window.dimensions = {
      columns = 100;
      lines = 30;
    };
    window.padding = {
      x = 5;
      y = 5;
    };
  };
}
