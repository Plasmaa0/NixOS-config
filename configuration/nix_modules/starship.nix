{ config, ... }: {
  programs.starship.enable = true;
  programs.starship.settings = builtins.fromTOML (builtins.readFile ../dotfiles/starship.toml);
}