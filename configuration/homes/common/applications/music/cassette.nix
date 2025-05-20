{
  config,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/${config.home.username}" = {
    directories = [".cache/cassette" ".local/share/cassette"];
  };
  home.packages = with pkgs; [
    cassette
  ];
}
