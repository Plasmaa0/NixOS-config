{...}: {
  flake.homeModules.applications = {pkgs, ...}: {
    home.packages = with pkgs; [
      gparted
      ntfsprogs
      exfatprogs
    ];
  };
}
