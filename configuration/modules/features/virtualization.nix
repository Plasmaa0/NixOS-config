{...}: {
  flake.nixosModules.virtualization = {
    pkgs,
    self,
    ...
  }: {
    programs.dconf.enable = true;
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = ["/etc/libvirt/qemu"];
    };
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true; # TPM support (required for Windows 11)
      };
    };
    programs.virt-manager.enable = true;
    services.spice-vdagentd.enable = true;
    services.qemuGuest.enable = true;
    users.users.plasmaa0.extraGroups = ["libvirtd" "kvm"];
    environment.systemPackages = with pkgs; [
      quickemu
      quickgui
    ];
  };
}
