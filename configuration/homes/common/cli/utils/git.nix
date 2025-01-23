{...}: {
  programs.gpg.enable = true;
  programs.git = {
    enable = true;
    # userName  = ""; # defined in secrets/secrets.nix
    # userEmail = ""; # defined in secrets/secrets.nix
    signing = {
      signByDefault = true;
      key = null;
    };
    aliases = {
      root = "rev-parse --show-toplevel";
      gh = "!git remote -v | grep github.com | grep fetch | head -1 | awk '{print $2}' | sed 's|git@github.com:|https://github.com/|' | xargs xdg-open";
    };
  };
  programs.gitui = {
    enable = true;
  };
}
