{lib, ...}: {
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
  programs.home-manager.enable = true;
  xsession.scriptPath = ".hm-xsession";
  imports = [
    ./secrets/secrets.nix
    ./shell_templates

    ./user-stylix.nix
  ];

  home.persistence."/persist" = {
    directories = [
      {
        # intent was to make ALL users have ~/data, but its currently not possible
        # wait for https://github.com/nix-community/impermanence/pull/309 to be merged
        # until then it just mounts /persist/data to /data (not intended ~/data)
        # currently solved via home.activation script that creates symlink from /data to $HOME/data
        # see below
        directory = "data";
        home = lib.mkForce null;
      }
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"

      ".gnupg"
      ".ssh"
      ".password-store"
      ".cache/dconf"
      ".config/pulse"
      ".config/Throne"
      ".local/share/applications"
      ".local/share/Steam"
      ".local/share/CKAN"
      ".steam"
      ".factorio"
    ];
    files = [
      ".steampath"
      ".local/share/nix/trusted-settings.json"
      # ".steampid"
    ];
  };
  home.activation.symlink_persist_data = lib.hm.dag.entryAfter ["linkGeneration"] ''
    run ln -s /data $HOME/data || true
  '';

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
