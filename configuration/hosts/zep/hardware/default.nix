{lib, ...}: let
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/f6581f1c3b137086e42a08a906bdada63045f991.tar.gz";
    sha256 = "sha256:1qjivy929fpjf736f78v6hdhv64jgx2m1aff85w1d3cw7c4ppmag";
  };
in {
  imports = builtins.abort "CHECK hardware-configuration.nix !!" [
    ./hardware-configuration.nix

    "${nixos-hardware}/common/cpu/amd"
    "${nixos-hardware}/common/gpu/nvidia/prime.nix"
    "${nixos-hardware}/common/gpu/nvidia/ada-lovelace"
    "${nixos-hardware}/common/pc/laptop"
    "${nixos-hardware}/common/pc/ssd"
  ];

  hardware.nvidia = {
    prime = builtins.abort "CHECK intelBusId AND nvidiaBusId !!" {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    dynamicBoost.enable = lib.mkDefault true;
  };

  services = {
    asusd.enable = lib.mkDefault true;

    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
       KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = builtins.trace "check system.stateVersion" "24.05"; # Did you read the comment?
}
