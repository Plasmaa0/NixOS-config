{
  config,
  pkgs,
  ...
}: {
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = false; # in case canTouchEfiVariables doesn't work for your system
        device = "nodev";
        useOSProber = true;
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
    # plymouth = {
    #   enable = true;
    #   theme = "rings";
    #   themePackages = with pkgs; [
    #     (adi1090x-plymouth-themes.override {selected_themes = [ "rings" ];})
    #   ];
    # };
    # # Enable "Silent Boot"
    # consoleLogLevel = 0;
    # initrd.verbose = false;
    # kernelParams = [
    #   "quiet"
    #   "splash"
    #   "boot.shell_on_fail"
    #   "loglevel=3"
    #   "rd.systemd.show_status=false"
    #   "rd.udev.log_level=3"
    #   "udev.log_priority=3"
    # ];
    # # Hide the OS choice for bootloaders.
    # # It's still possible to open the bootloader list by pressing any key
    # # It will just not appear on screen unless a key is pressed
    # loader.timeout = 0;
  };
}
