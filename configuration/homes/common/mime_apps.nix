{...}:{
  home.xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["evince.desktop"];
      "text/x-tex" = ["texstudio.desktop"];
      "text/html" = ["org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/http" = ["org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/https" = ["org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/about" = ["org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/unknown" = ["org.qutebrowser.qutebrowser.desktop"];
    };
  };
}
