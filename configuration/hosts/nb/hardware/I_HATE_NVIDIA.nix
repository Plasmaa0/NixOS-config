{
  config,
  lib,
  ...
}: let
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/f6581f1c3b137086e42a08a906bdada63045f991.tar.gz";
    sha256 = "sha256:1qjivy929fpjf736f78v6hdhv64jgx2m1aff85w1d3cw7c4ppmag";
  };
in {
  # NEW CONFIGURATION
  imports = [
    # -------------------replace here------
    # ------------------- \/  \/  \/ ------
    "${nixos-hardware}/huawei/machc-wa" # enables prime offload by default. Provides `nvidia-offload` command.
  ];

  # disable ppd which is enabled by default in <machc-wa>
  # i need this because i have power management made using tlp
  services.power-profiles-daemon.enable = lib.mkForce false;

  # NixOS supports "specialisations", which allow you to automatically generate
  # different boot profiles when rebuilding your system.
  # Because prime offload is enabled by defalut this is reasonable thing to do:
  # Specialisation which enables prime sync:
  specialisation = {
    nvidia-prime-sync.configuration = {
      system.nixos.tags = ["nvidia-prime-sync"];
      # enable prime sync INSTEAD of offload
      hardware.nvidia.prime = {
        sync.enable = lib.mkOverride 990 true;
        offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable false;
        };
      };
    };
  };
}
