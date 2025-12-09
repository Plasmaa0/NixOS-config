{
  lib,
  config,
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
      enable = false;
      finegrained = false;
    };

    modesetting.enable = false;
    open = false; # change back to open when https://github.com/NixOS/nixpkgs/issues/467814 is closed
    # open = let
    #   nvidiaPackage = config.hardware.nvidia.package;
    # in
    #   lib.mkOverride 990 (nvidiaPackage ? open && nvidiaPackage ? firmware);
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  services.acpid.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;

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
