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
      ".cache/AmneziaVPN.ORG"
      ".config/AmneziaVPN.ORG"
      ".local/share/applications"
      ".local/share/Steam"
      ".local/share/CKAN"
      ".steam"
      ".factorio"
    ];
    files = [
      ".steampath"
      # ".steampid"
    ];
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
