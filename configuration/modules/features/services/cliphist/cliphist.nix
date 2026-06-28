{...}: {
  flake.homeModules.service-cliphist = {pkgs, ...}: {
    services.cliphist.enable = true;
    home.persistence."/persist".directories = [".cache/cliphist"];
    home.packages = [
      (
        pkgs.writeShellApplication
        {
          name = "fuzzel-cliphist";
          bashOptions = [];
          runtimeInputs = with pkgs; [
            fuzzel
            gawk
            findutils
            gnugrep
            coreutils
            wl-clipboard
          ];
          text = builtins.readFile ./fuzzel-cliphist.sh;
        }
      )
    ];
  };
}
