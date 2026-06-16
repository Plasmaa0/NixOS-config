{pkgs, ...}: {
  programs.helix = {
    extraPackages = with pkgs; [
    ];
    languages = {
      language = [
      ];
      language-server = {
      };
    };
  };
}
