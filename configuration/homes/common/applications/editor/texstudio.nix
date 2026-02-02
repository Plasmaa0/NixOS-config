{pkgs, ...}: {
  home.packages = with pkgs; [texstudio];
  home.persistence."/persist".directories = [
    ".config/texstudio"
  ];
  mime.list = [
    {
      mimeTypes = ["text/x-tex"];
      handler = pkgs.texstudio;
    }
  ];
}
