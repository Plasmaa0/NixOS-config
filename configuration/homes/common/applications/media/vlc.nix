{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    vlc
  ];
  home.persistence."/persist/home/${config.home.username}" = {
    directories = [".local/share/vlc" ".cache/vlc"];
  };
}
