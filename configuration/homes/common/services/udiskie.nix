{pkgs, ...}: {
  services.udiskie = {
    enable = true;
    settings = {
      # https://github.com/nix-community/home-manager/issues/632
      program_options = {
        file_manager = "${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi";
      };
    };
  };
}
