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

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" "sdhci_pci"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.initrd.systemd.enable = true;
  hardware.amdgpu.initrd.enable = true;
  boot.kernelModules = ["kvm-amd"];
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "pcie_aspm.policy=powersupersave"
    "amdgpu.gpu_recovery=1"
    "amdgpu.dcdebugmask=0x12"
    "acpi.prefer_microsoft_dsm_guid=1"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [
        "defaults"
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
        "size=25%"
        "mode=755"
      ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
      neededForBoot = true;
    };

    "/persist/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "btrfs";
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
      neededForBoot = true;
    };

    "/persist/data" = {
      device = "/dev/disk/by-label/data";
      fsType = "ntfs";
    };
  };
  swapDevices = [
    {device = "/dev/disk/by-label/swap";}
    {
      device = "/var/swapfile";
      size = 24 * 1024;
    }
  ];
  zramSwap.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp103s0f4u1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
