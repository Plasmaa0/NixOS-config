{pkgs, ...}: {
  programs.fish.plugins = with pkgs.fishPlugins; [
    {
      name = "bang-bang"; # !! - previous command, !$ - last word of previous command
      inherit (bang-bang) src;
    }
    {
      name = "done"; # send notification if command is taking too long and finished when terminal is not focused
      inherit (done) src;
    }
    {
      name = "pisces"; # auto pairs like () "" etc
      inherit (pisces) src;
    }
  ];
}
