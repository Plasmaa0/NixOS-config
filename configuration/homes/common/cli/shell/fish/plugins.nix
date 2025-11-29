{pkgs, ...}: {
  programs.fish.plugins = with pkgs.fishPlugins; [
    {
      name = "bang-bang";
      inherit (bang-bang) src;
    }
    {
      name = "done";
      inherit (done) src;
    }
    {
      name = "pisces";
      inherit (pisces) src;
    }
  ];
}
