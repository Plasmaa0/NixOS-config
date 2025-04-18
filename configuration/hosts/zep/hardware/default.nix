{
  lib,
  config,
  ...
}: let
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/f6581f1c3b137086e42a08a906bdada63045f991.tar.gz";
    sha256 = "sha256:1qjivy929fpjf736f78v6hdhv64jgx2m1aff85w1d3cw7c4ppmag";
  };
in {
  imports = [
    ./hardware-configuration.nix

    # "${nixos-hardware}/common/cpu/amd" # sets hardware.cpu.amd.updateMicrocode which is already done in ./hardware-configuration.nix
    # "${nixos-hardware}/common/cpu/amd/pstate.nix" # sets kernelParams = [ "amd_pstate=active" ];

    "${nixos-hardware}/common/gpu/nvidia/prime.nix"
    "${nixos-hardware}/common/gpu/nvidia/ada-lovelace"

    "${nixos-hardware}/common/pc/laptop"
    "${nixos-hardware}/common/pc/ssd"
  ];

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
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
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
