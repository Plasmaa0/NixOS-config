{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # boot.initrd.availableKernelModules = ["xhci_pci" "nvme"];
  # boot.initrd.kernelModules = [];
  # boot.initrd.systemd.enable = true;
  # boot.kernelModules = ["kvm-intel"];
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.extraModulePackages = [];

  # fileSystems = {
  #   "/" = {
  #     device = "none";
  #     fsType = "tmpfs";
  #     neededForBoot = true;
  #     options = [
  #       "defaults"
  #       # "size=2G"
  #       "size=25%"
  #       "mode=755"
  #     ];
  #   };

  #   "/home" = {
  #     device = "none";
  #     fsType = "tmpfs";
  #     neededForBoot = true;
  #     options = [
  #       "defaults"
  #       # "size=2G"
  #       "size=25%"
  #       "mode=755"
  #     ];
  #   };

  #   "/persist" = {
  #     device = rootPartition;
  #     fsType = "ext4";
  #     neededForBoot = true;
  #   };

  #   "/persist/home" = {
  #     device = homePartition;
  #     fsType = "btrfs";
  #     neededForBoot = true;
  #   };

  #   "/boot" = {
  #     device = bootPartition;
  #     fsType = "vfat";
  #     options = ["fmask=0077" "dmask=0077"];
  #     neededForBoot = true;
  #   };
  # };

  # swapDevices = [
  #   {device = swapPartition;}
  #   {
  #     device = "/var/swapfile";
  #     size = 16 * 1024;
  #   }
  # ];
  zramSwap.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
