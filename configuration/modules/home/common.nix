{...}: {
  flake.homeModules.common = {lib, ...}: {
    programs.home-manager.enable = true;
    xsession.scriptPath = ".hm-xsession";

    home.persistence."/persist" = {
      directories = [
        {
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
      ];
    };
    home.activation.symlink_persist_data = lib.hm.dag.entryAfter ["linkGeneration"] ''
      run ln -s /data $HOME/data || true
    '';

    home.stateVersion = "24.05";
  };
}
