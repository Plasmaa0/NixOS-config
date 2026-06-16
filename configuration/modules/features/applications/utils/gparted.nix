{...}: {
  flake.homeModules.application-utils-gparted = {pkgs, ...}: {
    home.packages = with pkgs; [
      gparted
      ntfsprogs
      exfatprogs
    ];
  };
}
