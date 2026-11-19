{...}: {
  flake.homeModules.service-handy = {
    pkgs,
    lib,
    ...
  }: let
    inherit (pkgs) handy;
    handy-exe = lib.getExe handy;
  in {
    home.persistence."/persist".directories = [".cache/huggingface" ".local/share/com.pais.handy"];
    home.packages = [handy pkgs.wtype pkgs.wl-clipboard];
    programs.niri.settings = {
      spawn-at-startup = [{argv = ["${handy-exe}" "--start-hidden"];}];
      binds."Mod+Shift+F23".action = {spawn-sh = "${handy-exe} --toggle-transcription";};
    };
  };
}
