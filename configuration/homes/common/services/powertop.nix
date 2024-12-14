{pkgs, ...}: {
  home.packages = with pkgs; [
    powertop
  ];
}
