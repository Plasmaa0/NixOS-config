{pkgs, ...}: {
  home.packages = with pkgs; [
    diffnav
    diff-so-fancy
  ];
  programs.fish.shellAbbrs = {
    nixrepl = ''nix repl --expr "{pkgs = import <nixpkgs> {};}"'';
    venv = "source venv/bin/activate.fish";
    olr = "ollama run";
    olp = "ollama ps";
    olP = "ollama pull";
    ols = "ollama stop";
    icat = "wezterm imgcat";
    gd = "git diff --color | diff-so-fancy";
    gD = "git diff --color | diffnav";
    glg = "git log --graph --decorate --oneline";
    wget = "aria2c";
  };
}
