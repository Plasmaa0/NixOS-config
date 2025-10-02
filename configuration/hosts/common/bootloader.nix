{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];
  environment.systemPackages = [
    pkgs.sbctl
  ];
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = ["/var/lib/sbctl"];
  };

  # Bootloader.
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = false;
        efiSupport = true;
        efiInstallAsRemovable = false; # in case canTouchEfiVariables doesn't work for your system
        device = "nodev";
        useOSProber = true;
        extraEntries = ''
          menuentry "Shut Down" {
            halt
          }
          menuentry "Reboot" {
            reboot
          }
        '';
        theme = pkgs.stdenv.mkDerivation {
          pname = "distro-grub-themes";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
          installPhase = "cp -r customize/nixos $out";
        };
      };
    };
    # plymouth settings
    plymouth = let
      theme_name = "splash";
    in {
      enable = true;
      theme = theme_name;
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {selected_themes = [theme_name];})
      ];
    };
    # # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.systemd.enable = true;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    # loader.timeout = 0;
  };
}
