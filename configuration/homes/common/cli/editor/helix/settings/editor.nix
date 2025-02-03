{...}: {
  programs.helix.settings.editor = {
    line-number = "relative";
    mouse = true;
    cursorline = true;
    rulers = [100];
    auto-info = true;
    gutters = ["diagnostics" "spacer" "line-numbers" "spacer" "diff"];
    end-of-line-diagnostics = "hint";
    inline-diagnostics = {
      cursor-line = "info";
      other-lines = "error";
      max-wrap = 50;
    };
    lsp = {
      display-messages = true;
      display-inlay-hints = true;
      goto-reference-include-declaration = false;
    };
    jump-label-alphabet = "asdfqwerzxcvjklmiuopghtybn";
    cursor-shape = {
      insert = "bar";
      normal = "block";
      select = "underline";
    };
    file-picker = {
      hidden = false;
    };
    indent-guides = {
      render = true;
      character = "";
      skip-levels = 1;
    };
    soft-wrap = {
      enable = true;
      max-wrap = 25;
      max-indent-retain = 0;
    };
    statusline = let
      sep = "separator";
      sp = "spacer";
    in {
      left = [
        "spinner"
        "mode"
        "file-modification-indicator"
        "read-only-indicator"
      ];
      center = [
        "version-control"
        sep
        "file-name"
      ];
      right = [
        "diagnostics"
        sep
        "workspace-diagnostics"
        sp

        "selections"
        sp

        "position"
        sep
        "position-percentage"
        sp

        "file-encoding"
        "file-line-ending"
        "file-type"
      ];
      separator = " ";
      mode.normal = "N 󰅨";
      mode.insert = "I 󰏪";
      mode.select = "S 󰒉";
    };
    whitespace = {
      characters = {
        space = "·";
        nbsp = "⍽";
        nnbsp = "␣";
        tab = "→";
        newline = "⏎";
        tabpad = "·";
      };
    };
  };
}
