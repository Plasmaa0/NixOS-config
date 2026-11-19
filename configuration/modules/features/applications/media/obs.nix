{...}: {
  flake.nixosModules.application-media-obs-v4l2loopback = {pkgs, ...}: {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };
  };
  flake.homeModules.application-media-obs = {pkgs, ...}: {
    home.persistence."/persist".directories = [".config/obs-studio"];
    home.packages = [pkgs.helvum];
  };
}
