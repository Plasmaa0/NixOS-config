{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.nb = {
    lib,
    pkgs,
    ...
  }: {
    imports = with self.nixosModules; [
      impermanence
      ananicy
      audio
      automount
      autorandr
      autoUpgrade
      bootloader
      displayManager
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
      steam
      vial
      stylix
      ./nb/_default.nix
    ];

    hidpi = {
      enable = true;
      dpi = 192;
    };

    programs.fish.useBabelfish = true;
    programs.i3lock.enable = true;

    hardware.bluetooth.powerOnBoot = false;
    programs.dconf.enable = true;

    networking.hostName = "nb";

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.trusted-users = ["plasmaa0"];
    nix.package = lib.mkForce pkgs.nix;

    users.users = {
      plasmaa0 = {
        isNormalUser = true;
        description = "plasmaa0";
        extraGroups = ["networkmanager" "wheel" "dialout"];
        password = import ../home/secrets/_plasmaa0_password.nix;
      };
      root.hashedPasswordFile = toString ../home/secrets/root_hashed_password;
    };

    system.activationScripts.profile-init.text = ''
      ln -sfn /home/plasmaa0/.local/state/nix/profiles/profile /home/plasmaa0/.nix-profile
    '';

    home-manager = {
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

  flake.nixosConfigurations.nb = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.nb
    ];
    specialArgs = {
      inherit inputs self;
    };
  };
}
