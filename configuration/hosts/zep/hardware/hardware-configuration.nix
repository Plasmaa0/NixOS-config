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
  boot.initrd.kernelModules = [];
  boot.initrd.systemd.enable = true;
  boot.kernelModules = ["kvm-amd"];
  boot.kernelPackages = pkgs.linuxPackages_zen;
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
      device = "/dev/disk/by-uuid/5f63edb3-b587-410c-96ee-88eb964677f1";
      fsType = "ext4";
      neededForBoot = true;
    };

    "/persist/home" = {
      device = "/dev/disk/by-uuid/4f0a4994-a958-4d24-8f75-1803392a44c0";
      fsType = "btrfs";
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/74D4-6E08";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
      neededForBoot = true;
    };
  };
  swapDevices = [
    {device = "/dev/disk/by-uuid/5d2bbd8b-a8b3-4070-b287-532ec7d7748f";}
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
  # networking.interfaces.enp103s0f4u1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
