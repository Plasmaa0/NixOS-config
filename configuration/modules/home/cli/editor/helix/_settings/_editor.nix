{...}: {
  programs.helix.settings.editor = {
    line-number = "relative";
    mouse = true;
    cursorline = true;
    color-modes = true;
    rulers = [100];
    scrolloff = 15;
    scroll-lines = 1;
    auto-info = true;
    bufferline = "multiple";
    gutters = ["diagnostics" "spacer" "line-numbers" "spacer" "diff"];
    end-of-line-diagnostics = "hint";
    rainbow-brackets = true;
    inline-diagnostics = {
      cursor-line = "info";
      other-lines = "error";
      max-wrap = 50;
    };
    lsp = {
      display-messages = true;
      display-progress-messages = true;
      display-inlay-hints = true;
      goto-reference-include-declaration = false;
      display-color-swatches = true;
      auto-signature-help = false;
    };
    idle-timeout = 50;
    completion-timeout = 10;
    completion-trigger-len = 1;
    jump-label-alphabet = "jfkdls;aurieowpqnvmcxz";
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
      max-indent-retain = 40;
      wrap-at-text-width = false;
    };
    trim-trailing-whitespace = true;
    statusline = let
      sep = "separator";
      sp = "spacer";
    in {
      left = [
        "spinner"
        "mode"
        "file-modification-indicator"
        "read-only-indicator"
        "diagnostics"
        sep
        "workspace-diagnostics"
      ];
      center = [
        "file-name"
        sep
        "version-control"
      ];
      right = [
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
      separator = "  ";
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
