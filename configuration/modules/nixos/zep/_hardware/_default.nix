{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./_hardware-configuration.nix
  ];

  services.fstrim.enable = lib.mkDefault true;

  hardware.amdgpu.opencl.enable = true;
  hardware.nvidia = {
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:102:0:0";
      nvidiaBusId = "PCI:101:0:0";
    };

    dynamicBoost.enable = lib.mkDefault true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    modesetting.enable = true;
    open = let
      nvidiaPackage = config.hardware.nvidia.package;
    in
      lib.mkOverride 990 (nvidiaPackage ? open && nvidiaPackage ? firmware);
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  services.acpid.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [mesa libglvnd libGL libGLX];
  };

  specialisation = {
    powersave = {
      configuration = {
        system.nixos.tags = ["powersave"];
        hardware.nvidia.prime.offload.enable = lib.mkForce false;
        hardware.nvidia.prime.sync.enable = lib.mkForce false;
        hardware.nvidia.prime.reverseSync.enable = lib.mkForce false;
        services.xserver.videoDrivers = lib.mkForce ["amdgpu"];
        boot.blacklistedKernelModules = lib.mkForce ["nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm"];
        boot.extraModprobeConfig = lib.mkForce ''
          blacklist nouveau
          blacklist nvidia
          blacklist nvidia_drm
          blacklist nvidia_modeset
          blacklist nvidia_uvm
          options nouveau modeset=0
        '';
        services.udev.extraRules = lib.mkForce ''
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
        '';
        hardware.nvidia.nvidiaSettings = lib.mkForce false;
        hardware.nvidia.powerManagement.enable = lib.mkForce false;
        hardware.nvidia.powerManagement.finegrained = lib.mkForce false;
      };
    };
  };

  services.udev.extraHwdb = ''
    evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
     KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
  '';
}
