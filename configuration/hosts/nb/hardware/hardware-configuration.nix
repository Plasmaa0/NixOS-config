# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  rootPartition = "/dev/disk/by-uuid/74219b09-f02e-43f9-a15b-375ff4037772";
  bootPartition = "/dev/disk/by-uuid/B24C-64BF";
  homePartition = "/dev/disk/by-uuid/12d128c8-46ef-4b58-9c59-f7cc2ce799c3";
  swapPartition = "/dev/disk/by-uuid/c3ee8d1f-0771-48a0-b379-508a8acd8be5";
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme"];
  boot.initrd.kernelModules = [];
  boot.initrd.systemd.enable = true;
  boot.kernelModules = ["kvm-intel"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [];

  # fileSystems = {
  #   "/" = {
  #     device = rootPartition;
  #     fsType = "ext4";
  #   };

  #   #old uuid of /boot C46E-7DFA
  #   "/boot" = {
  #     device = bootPartition;
  #     fsType = "vfat";
  #     options = ["fmask=0077" "dmask=0077"];
  #   };

  #   "/home" = {
  #     device = homePartition;
  #     fsType = "btrfs";
  #   };
  # };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [
        "defaults"
        # "size=2G"
        "size=25%"
        "mode=755"
      ];
    };

    "/home" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [
        "defaults"
        # "size=2G"
        "size=25%"
        "mode=755"
      ];
    };

    "/persist" = {
      device = rootPartition;
      fsType = "ext4";
      neededForBoot = true;
    };

    "/persist/home" = {
      device = homePartition;
      fsType = "btrfs";
      neededForBoot = true;
    };

    "/boot" = {
      device = bootPartition;
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
      neededForBoot = true;
    };
  };

  swapDevices = [
    {device = swapPartition;}
    {
      device = "/var/swapfile";
      size = 16 * 1024;
    }
  ];
  zramSwap.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
