{
  inputs,
  config,
  ...
}: {
  programs.home-manager.enable = true;
  xsession.scriptPath = ".hm-xsession";
  imports = [
    ./secrets/secrets.nix
    ./shell_templates

    ./stylix.nix
    inputs.impermanence.homeManagerModules.impermanence
  ];

  home.persistence."/persist/home/${config.home.username}" = {
    allowOther = true;
    directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"

      ".gnupg"
      ".ssh"
      ".jump"
      ".password-store"
      ".cache/dconf"
      {
        directory = ".config/pulse";
        # mode = "0766";
        method = "symlink";
      }
      ".local/share/applications"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
      {
        directory = ".steam";
        method = "symlink";
      }
      {
        directory = ".factorio";
        method = "symlink";
      }
    ];
    files = [
      ".steampath"
      ".steampid"
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
