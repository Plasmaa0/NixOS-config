{...}: {
  programs.fish.binds = {
    "\\cz" = {
      command = "fg";
      silent = true;
      repaint = true;
    };
  };
}
