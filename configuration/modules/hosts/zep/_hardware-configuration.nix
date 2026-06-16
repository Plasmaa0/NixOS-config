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

  boot.supportedFilesystems = ["ntfs"];
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" "sdhci_pci"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.initrd.systemd.enable = true;
  hardware.amdgpu.initrd.enable = true;
  boot.kernelModules = ["kvm-amd"];
  boot.kernelParams = [
    "iommu=1"
    "amd_pstate=passive"
    "pcie_aspm.policy=powersupersave"
    "acpi.prefer_microsoft_dsm_guid=1"
    "amdgpu.gpu_recovery=1"
    "amdgpu.dcdebugmask=0x210"
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
      fsType = "ntfs-3g";
      options = [
        "rw"
        "uid=1000"
        "gid=100"
      ];
    };
  };
  powerManagement.enable = true;
  swapDevices = [
    {device = "/dev/disk/by-label/swap";}
    {
      device = "/var/swapfile";
      size = 24 * 1024;
    }
  ];
  zramSwap = {
    enable = true;
    priority = 100;
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
