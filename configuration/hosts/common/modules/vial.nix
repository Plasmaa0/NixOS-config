{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.vial
  ];
  services.udev.packages = with pkgs; [
    vial
  ];
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
}
