{...}: {
  flake.homeModules.application-media-kdenlive = {pkgs, ...}: {
    home.packages = with pkgs; [kdePackages.kdenlive];
    home.persistence."/persist" = {
      directories = [
        ".config/kdenlive"
        ".local/share/kdenlive"
        ".cache/kdenlive"
      ];
      files = [".config/kdenliverc"];
    };
  };
}
