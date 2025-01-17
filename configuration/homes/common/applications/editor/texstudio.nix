{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [texstudio];
  home.persistence."/persist/home/${config.home.username}".directories = [
    ".config/texstudio"
  ];
  mime.list = [
    {
      mimeTypes = ["text/x-tex"];
      handler = pkgs.texstudio;
    }
  ];
}
