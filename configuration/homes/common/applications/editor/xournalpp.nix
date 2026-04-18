{pkgs, ...}: {
  home.packages = with pkgs; [
    xournalpp
  ];
  home.persistence."/persist".directories = [
    ".cache/xournalpp/"
    ".config/xournalpp/"
    ".local/state/xournalpp/"
  ];
  xdg.desktopEntries."xournalpp-hidpi" = {
    name = "Xournal++ (HiDPI)";
    exec = "env GDK_SCALE=2 xournalpp-wrapper %f";
    type = "Application";
    terminal = false;
    startupNotify = true;
    categories = ["Office" "GNOME" "GTK"];
    mimeType = ["application/x-xoj" "application/x-xojpp" "application/x-xopp" "application/x-xopt" "application/pdf"];
    icon = "com.github.xournalpp.xournalpp";
  };
}
