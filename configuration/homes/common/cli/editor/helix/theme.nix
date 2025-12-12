{config, ...}: {
  programs.helix = {
    settings.theme = "stylix";
    themes = {
      stylix = let
        c = config.lib.stylix.colors.withHashtag;
      in {
        "attributes" = "base09";
        "attribute" = "base0D";
        "comment" = {
          fg = "base03";
          modifiers = ["italic"];
        };
        "constant" = "base09";
        "constant.builtin" = "base08";
        "constant.character.escape" = "base0C";
        "constant.numeric" = "base0D";
        "constructor" = "base0D";
        "debug" = "base03";
        "diff.plus" = "base0B";
        "diff.delta" = "base09";
        "diff.minus" = "base08";
        "error" = {
          fg = "base08";
          modifiers = ["bold"];
        };
        "function" = "base0B";
        "function.macro" = {fg = "base0C";};
        "function.builtin" = {fg = "base0D";};
        "hint" = "base03";
        "info" = "base0D";
        "keyword" = {fg = "base08";};
        "keyword.directive" = "base0D";
        "label" = "base08";
        "namespace" = "base05";
        "operator" = "base08";
        "special" = "base09"; # matching characters in pickers when fuzzy searching something
        "module" = "base0D";
        "string" = "base0E";
        "type" = "base0B";
        "type.builtin" = {fg = "base08";};
        "variable" = "base07";
        "variable.other.member" = "base06";
        "variable.builtin" = "base08";
        "variable.parameter" = "base09";
        "warning" = "base09";
        "punctuation" = "base04";
        "rainbow" = ["base08" "base09" "base0A" "base0B" "base0C"];

        "markup.bold" = {
          fg = "base09";
          modifiers = ["bold"];
        };
        "markup.heading" = "base0B";
        "markup.italic" = {
          fg = "base0A";
          modifiers = ["italic"];
        };
        "markup.link.text" = "base08";
        "markup.link.url" = {
          fg = "base09";
          modifiers = ["underlined"];
        };
        "markup.list" = "base08";
        "markup.quote" = "base0C";
        "markup.raw" = "base0B";
        "markup.strikethrough" = {modifiers = ["crossed_out"];};

        "diagnostic" = {modifiers = ["underlined"];};
        "diagnostic.unnecessary" = {modifiers = ["dim"];};
        "diagnostic.deprecated" = {modifiers = ["crossed_out"];};
        "diagnostic.warning" = {
          underline = {
            color = "orange";
            style = "curl";
          };
        };
        "diagnostic.error" = {
          underline = {
            color = "red";
            style = "curl";
          };
        };
        "diagnostic.info" = {
          underline = {
            color = "base8";
            style = "curl";
          };
        };
        "diagnostic.hint" = {
          underline = {
            color = "base6";
            style = "curl";
          };
        };

        "ui.background" = {bg = "base00";};
        "ui.bufferline.active" = {
          fg = "base00";
          bg = "base03";
          modifiers = ["bold"];
        };
        "ui.bufferline" = {
          fg = "base04";
          bg = "base00";
        };
        "ui.cursor" = {
          fg = "base05";
          modifiers = ["reversed"];
        };
        "ui.cursor.primary" = {
          fg = "base07";
          modifiers = ["reversed"];
        };
        "ui.cursor.insert" = {
          fg = "base0A";
          modifiers = ["reversed"];
        };
        "ui.cursor.match" = {
          fg = "base0A";
          modifiers = ["reversed"];
        };
        "ui.cursor.select" = {
          fg = "base0A";
          modifiers = ["reversed"];
        };
        "ui.cursorline.primary" = {
          fg = "base05";
          bg = "base01";
        };
        "ui.gutter" = {bg = "base00";};
        "ui.help" = {
          fg = "base06";
          bg = "base01";
        };
        "ui.linenr" = {
          fg = "base03";
          bg = "base00";
        };
        "ui.linenr.selected" = {
          fg = "base04";
          bg = "base01";
          modifiers = ["bold"];
        };
        "ui.menu" = {
          fg = "base05";
          bg = "base01";
        };
        "ui.menu.scroll" = {
          fg = "base03";
          bg = "base01";
        };
        "ui.menu.selected" = {
          fg = "base01";
          bg = "base04";
        };
        "ui.popup" = {bg = "base01";};
        "ui.selection" = {bg = "base02";};
        "ui.selection.primary" = {bg = "base02";};
        "ui.statusline" = {
          fg = "base04";
          bg = "base01";
        };
        "ui.statusline.inactive" = {
          bg = "base01";
          fg = "base03";
        };
        "ui.statusline.insert" = {
          fg = "base00";
          bg = "base0B";
        };
        "ui.statusline.normal" = {
          fg = "base00";
          bg = "base03";
        };
        "ui.statusline.select" = {
          fg = "base00";
          bg = "base0F";
        };
        "ui.text" = "base05";
        "ui.text.focus" = {
          fg = "base0A";
          modifiers = ["bold"];
        };
        "ui.text.inactive" = {
          fg = "base09";
          modifiers = ["bold"];
        };
        "ui.text.directory" = {
          fg = "base04";
          modifiers = ["dim"];
        };
        "ui.virtual.indent-guide" = {fg = "base03";};
        "ui.virtual.inlay-hint" = {fg = "base03";};
        "ui.virtual.ruler" = {bg = "base01";};
        "ui.virtual.whitespace" = "base4";
        "ui.virtual.jump-label" = {
          fg = "base08";
          modifiers = ["bold"];
        };
        "ui.window" = {bg = "base01";};

        palette = {
          inherit (c) base00; # Default Background
          inherit (c) base01; # Lighter Background (Used for status bars, line number and folding marks)
          inherit (c) base02; # Selection Background
          inherit (c) base03; # Comments, Invisibles, Line Highlighting
          inherit (c) base04; # Dark Foreground (Used for status bars)
          inherit (c) base05; # Default Foreground, Caret, Delimiters, Operators
          inherit (c) base06; # Light Foreground (Not often used)
          inherit (c) base07; # Light Background (Not often used)
          inherit (c) base08; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
          inherit (c) base09; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
          inherit (c) base0A; # Classes, Markup Bold, Search Text Background
          inherit (c) base0B; # Strings, Inherited Class, Markup Code, Diff Inserted
          inherit (c) base0C; # Support, Regular Expressions, Escape Characters, Markup Quotes
          inherit (c) base0D; # Functions, Methods, Attribute IDs, Headings
          inherit (c) base0E; # Keywords, Storage, Selector, Markup Italic, Diff Changed
          inherit (c) base0F; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
        };
      };
    };
  };
}
