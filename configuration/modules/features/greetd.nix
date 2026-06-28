{...}: {
  flake.nixosModules.greetd = {
    pkgs,
    lib,
    ...
  }: let
    tuigreet = lib.getExe pkgs.tuigreet;
    niri-session = "${pkgs.niri-unstable}/share/wayland-sessions";
  in {
    environment.persistence."/persist".directories = [
      {
        directory = "/var/cache/tuigreet";
        user = "greeter";
        group = "greeter";
        mode = "0755";
      }
    ];
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --time --remember --remember-session --sessions ${niri-session}";
          user = "greeter";
        };
      };
    };
  };
}
