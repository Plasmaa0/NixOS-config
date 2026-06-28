{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.zep = {
    lib,
    pkgs,
    config,
    ...
  }: {
    system.stateVersion = "24.11";
    imports = with self.nixosModules; [
      impermanence
      ananicy
      audio
      automount
      autoUpgrade
      bootloader
      greetd
      firewall
      fonts
      gamemode
      garbageCollect
      gnupg
      keymap
      networking
      nix-ld
      power_management
      printing
      ssh
      systemd-lock-handler
      time_and_i18n
      touchpad
      HighDPI
      bluetooth
      ollama
      steam
      vial
      weylus
      stylix
      host-enable-niri-support
      secrets
      ./_hardware-configuration.nix
    ];

    hidpi = {
      enable = true;
      dpi = 180;
    };

    programs.fish.useBabelfish = true;
    programs.i3lock.enable = true;

    security.polkit.enable = true;
    hardware.sensor.iio.enable = true;
    hardware.bluetooth.powerOnBoot = false;
    programs.dconf.enable = true;

    nixpkgs.config.allowUnfree = true;

    services.asusd.enable = true;
    environment.persistence."/persist".directories = ["/etc/asusd"];

    networking.hostName = "zep";

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.trusted-users = ["plasmaa0"];
    nix.package = lib.mkForce pkgs.nix;

    users.users = {
      plasmaa0 = {
        isNormalUser = true;
        description = "plasmaa0";
        extraGroups = ["networkmanager" "wheel" "dialout"];
      };
    };

    system.activationScripts.profile-init.text = ''
      ln -sfn /home/plasmaa0/.local/state/nix/profiles/profile /home/plasmaa0/.nix-profile
    '';

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
      open = false;
      # open = let
      #   nvidiaPackage = config.hardware.nvidia.package;
      # in
      #   lib.mkOverride 990 (nvidiaPackage ? open && nvidiaPackage ? firmware);
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

    # specialisation = {
    #   powersave = {
    #     configuration = {
    #       system.nixos.tags = ["powersave"];
    #       hardware.nvidia.prime.offload.enable = lib.mkForce false;
    #       hardware.nvidia.prime.sync.enable = lib.mkForce false;
    #       hardware.nvidia.prime.reverseSync.enable = lib.mkForce false;
    #       services.xserver.videoDrivers = lib.mkForce ["amdgpu"];
    #       boot.blacklistedKernelModules = lib.mkForce ["nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm"];
    #       boot.extraModprobeConfig = lib.mkForce ''
    #         blacklist nouveau
    #         blacklist nvidia
    #         blacklist nvidia_drm
    #         blacklist nvidia_modeset
    #         blacklist nvidia_uvm
    #         options nouveau modeset=0
    #       '';
    #       services.udev.extraRules = lib.mkForce ''
    #         ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
    #         ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
    #         ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
    #         ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
    #       '';
    #       hardware.nvidia.nvidiaSettings = lib.mkForce false;
    #       hardware.nvidia.powerManagement.enable = lib.mkForce false;
    #       hardware.nvidia.powerManagement.finegrained = lib.mkForce false;
    #     };
    #   };
    # };

    services.udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
       KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
    '';

    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs = {
        inherit inputs self;
      };
      users.plasmaa0 = {
        imports = [
          self.homeModules.stylix
          self.homeModules.plasmaa0
        ];
      };
    };
  };

  flake.nixosConfigurations.zep = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.zep
      inputs.home-manager.nixosModules.home-manager
    ];
    specialArgs = {
      inherit inputs self;
    };
  };
}
