{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  services.fstrim.enable = lib.mkDefault true;

  # environment.systemPackages = with pkgs; [
  #   cudaPackages.cudatoolkit
  #   cudaPackages.cudnn
  #   cudaPackages.cuda_cudart
  # ];
  # systemd.services.nvidia-control-devices = {
  #   wantedBy = ["multi-user.target"];
  #   serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
  # };
  # environment.sessionVariables = {
  #   CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
  #   LD_LIBRARY_PATH = lib.makeLibraryPath [
  #     "${pkgs.cudaPackages.cudatoolkit}"
  #     "${pkgs.cudaPackages.cudatoolkit}/lib64"
  #     pkgs.cudaPackages.cudnn
  #     pkgs.cudaPackages.cuda_cudart
  #     pkgs.stdenv.cc.cc.lib
  #   ];
  #   CUDA_MODULE_LOADING = "LAZY";
  # };

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
      # This is unreliable on the 4060;  works a few times, then hangs:
      enable = true;
      finegrained = true;
    };

    modesetting.enable = true;
    # open = false;
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
