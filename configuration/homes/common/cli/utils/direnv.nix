{...}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.persistence."/persist" = {
    directories = [".local/share/direnv"];
  };
}
