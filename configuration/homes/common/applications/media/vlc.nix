{pkgs, ...}: {
  home.packages = with pkgs; [
    vlc
  ];
  home.persistence."/persist" = {
    directories = [".local/share/vlc" ".cache/vlc" ".config/vlc"];
  };
}
