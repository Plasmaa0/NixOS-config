{
  config,
  lib,
  ...
}: let
  highlightTransparency = "0.5";
  getColorCh = colorName: channel: config.lib.stylix.colors."${colorName}-rgb-${channel}";
  rgb = color: ''rgb(${getColorCh color "r"}, ${getColorCh color "g"}, ${getColorCh color "b"})'';
  rgba = color: ''rgba(${getColorCh color "r"}, ${getColorCh color "g"}, ${getColorCh color "b"}, ${highlightTransparency})'';
in {
  programs.zathura = {
    enable = true;
    # extraConfig = "";
    mappings = {
      "<Right>" = "navigate next";
      "<Left>" = "navigate previous";
      "D" = ''set "first-page-column 1:1"'';
      "<A-D>" = ''set "first-page-column 1:2"'';
      "." = "focus_inputbar /"; # russian layout same search button
      "т" = "search forward"; # same purpose (russian т)
      "Т" = "search backward"; # same purpose (russian т)
    };
    options = lib.mkForce {
      synctex = true;
      # synctex-editor-command = "vim --servername VIM --remote +\%{lie} \%{input}";

      default-fg = rgb "base07";
      default-bg = rgb "base00";

      completion-bg = rgb "base01";
      completion-fg = rgb "base0E";
      completion-highlight-bg = rgb "base0B";
      completion-highlight-fg = rgb "base01";
      completion-group-bg = rgb "base02";
      completion-group-fg = rgb "base0D";

      statusbar-fg = rgb "base05";
      statusbar-bg = rgb "base02";

      notification-bg = rgb "base04";
      notification-fg = rgb "base07";
      notification-error-bg = rgb "base04";
      notification-error-fg = rgb "base08";
      notification-warning-bg = rgb "base04";
      notification-warning-fg = rgb "base09";

      inputbar-fg = rgb "base07";
      inputbar-bg = rgb "base03";

      recolor = true;
      recolor-lightcolor = rgb "base01";
      recolor-darkcolor = rgb "base07";

      index-fg = rgb "base06";
      index-bg = rgb "base01";
      index-active-fg = rgb "base01";
      index-active-bg = rgb "base0B";

      render-loading-bg = rgb "base04";
      render-loading-fg = rgb "base0F";

      highlight-color = rgba "base0C";
      highlight-fg = rgba "base07";
      highlight-active-color = rgba "base0B";
    };
  };
}
