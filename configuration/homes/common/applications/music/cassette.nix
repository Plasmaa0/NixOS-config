{pkgs, ...}: {
  home.persistence."/persist" = {
    directories = [".cache/cassette" ".local/share/cassette"];
  };
  home.packages = with pkgs; [
    cassette
  ];
}
