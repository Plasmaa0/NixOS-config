{pkgs, ...}:{
  home.packages = (with pkgs; [texstudio]);
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/x-tex" = ["texstudio.desktop"];
    };
  };
}
