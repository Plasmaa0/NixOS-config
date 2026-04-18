{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    android-tools
    /*
    adb reverse tcp:1701 tcp:1701
    adb reverse tcp:9001 tcp:9001
    */
    scrcpy
    qtscrcpy
  ];
  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = ["plasmaa0"];
  };
}
