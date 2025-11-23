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
  # https://gitlab.freedesktop.org/drm/amd/-/issues/3545#note_2538277
  # https://universal-blue.discourse.group/t/linux-bluefin-on-asus-laptop-with-amd-ryzen-ai-vivobook-m5406w/4071
  boot.kernelParams = [
    "iommu=1"
    # "mem_sleep_default=deep" # Adding mem_sleep_default=deep doesn't work on AMD systems.
    "amd_pstate=passive"
    "pcie_aspm.policy=powersupersave"
    # "pcie_aspm=off"
    "acpi.prefer_microsoft_dsm_guid=1"

    # Hopefully fixes for where the kernel sometimes hangs when suspending or hibernating
    #  (Though, I'm very suspicious of the Mediatek Wifi...)
    "amdgpu.gpu_recovery=1"

    # Can help solve flickering/glitching display issues since Scatter/Gather code was reenabled
    # One of this two disables PSR
    # enum DC_DEBUG_MASK {
    # 	DC_DISABLE_PIPE_SPLIT = 0x1,
    # 	DC_DISABLE_STUTTER = 0x2,
    # 	DC_DISABLE_DSC = 0x4,
    # 	DC_DISABLE_CLOCK_GATING = 0x8,
    # 	DC_DISABLE_PSR = 0x10,
    # 	DC_FORCE_SUBVP_MCLK_SWITCH = 0x20,
    # 	DC_DISABLE_MPO = 0x40,
    # 	DC_ENABLE_DPIA_TRACE = 0x80,
    # 	DC_ENABLE_DML2 = 0x100,
    # 	DC_DISABLE_PSR_SU = 0x200,
    # 	DC_DISABLE_REPLAY = 0x400,
    # 	DC_DISABLE_IPS = 0x800,
    # };
    # "amdgpu.dcdebugmask=0x12"
    # "amdgpu.dcdebugmask=0x10"
    # "amdgpu.dcdebugmask=0x200"
    # "amdgpu.dcdebugmask=0x212"
    "amdgpu.dcdebugmask=0x210"

    # Can help solve flickering/glitching display issues since Scatter/Gather code was reenabled
    # "amdgpu.sg_display=0"
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
