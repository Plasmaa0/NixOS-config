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
  };
  programs.gitui = {
    enable = true;
  };
}
