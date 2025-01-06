{pkgs, ...}: {
  home.packages = with pkgs; [texstudio];
  mime.list = [
    {
      mimeTypes = ["text/x-tex"];
      handler = pkgs.texstudio;
    }
  ];
}
