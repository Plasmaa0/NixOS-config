{...}: {
  flake.homeModules.services = {pkgs, ...}: {
    home.packages = with pkgs; [
      powertop
    ];
  };
}
