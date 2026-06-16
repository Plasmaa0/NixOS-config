{...}: {
  flake.homeModules.cli-terminal-wezterm = {...}: {
    programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
