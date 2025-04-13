{config, ...}: {
  programs.helix = {
    settings.theme = "stylix";
    themes = {
      stylix = let
        c = config.lib.stylix.colors;
      in {
        "ui.linenr.selected" = {bg = "base2";};
        "ui.text.focus" = {
          fg = "yellow";
          modifiers = ["bold"];
        };
        "ui.menu" = {
          fg = "base8";
          bg = "base3";
        };
        "ui.menu.selected" = {
          fg = "base2";
          bg = "yellow";
        };
        "ui.virtual.whitespace" = "base4";
        "ui.virtual.ruler" = {bg = "base1";};
        "ui.virtual.jump-label" = {
          fg = "red";
          modifiers = ["bold"];
        };

        "info" = "base8";
        "hint" = "base8";

        # background color
        "ui.background" = {bg = "base0";};

        # status bars, panels, modals, autocompletion
        "ui.statusline" = {
          fg = "base8";
          bg = "base2";
        };
        "ui.statusline.inactive" = {
          fg = "base8";
          bg = "base1";
        };
        "ui.popup" = {bg = "base3";};
        "ui.window" = {bg = "base3";};
        "ui.help" = {
          fg = "base8";
          bg = "base3";
        };

        # active line, highlighting
        "ui.selection" = {bg = "base2";};
        "ui.cursor.match" = {bg = "base4";};
        "ui.cursorline" = {bg = "base1";};

        # bufferline, inlay hints
        "ui.bufferline" = {
          fg = "base6";
          bg = "base2";
        };
        "ui.bufferline.active" = {
          fg = "green";
          bg = "base3";
        };
        "ui.virtual.inlay-hint" = {fg = "base4";};

        # comments, nord3 based lighter color
        "comment" = {
          fg = "base4";
          modifiers = ["italic"];
        };
        "ui.linenr" = {fg = "base4";};

        # cursor, variables, constants, attributes, fields
        "ui.cursor.primary" = {
          fg = "base7";
          modifiers = ["reversed"];
        };
        "attribute" = "blue";
        "variable" = "base8";
        "constant" = "orange";
        "variable.builtin" = "red";
        "constant.builtin" = "red";
        "namespace" = "base8";

        # base text, punctuation
        "ui.text" = {fg = "base8";};
        "punctuation" = "base4";

        # classes, types, primitives
        "type" = "green";
        "type.builtin" = {fg = "red";};
        "label" = "base8";

        # declaration, methods, routines
        "constructor" = "blue";
        "function" = "green";
        "function.macro" = {fg = "blue";};
        "function.builtin" = {fg = "blue";};

        # operator, tags, units, punctuations
        "operator" = "red";
        "variable.other.member" = "base8";

        # keywords, special
        "keyword" = {fg = "red";};
        "keyword.directive" = "blue";
        "variable.parameter" = "#f59762";

        # error
        "error" = {
          fg = "red";
          modifiers = ["bold"];
        };

        # annotations, decorators
        "special" = "#f59762";
        "module" = "#f59762";

        # warnings, escape characters, regex
        "warning" = "orange";
        "constant.character.escape" = {fg = "base8";};

        # strings
        "string" = "yellow";

        # integer, floating point
        "constant.numeric" = "purple";

        # vcs
        "diff.plus" = "green";
        "diff.delta" = "orange";
        "diff.minus" = "red";

        # make diagnostic underlined, to distinguish with selection text.
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
            color = "base8";
            style = "curl";
          };
        };
        "diagnostic.unnecessary" = {modifiers = ["dim"];};
        "diagnostic.deprecated" = {modifiers = ["crossed_out"];};

        # markup highlight, no need for `markup.raw` and `markup.list`, make them to be defaul
        "markup.heading" = "green";
        "markup.bold" = {
          fg = "orange";
          modifiers = ["bold"];
        };
        "markup.italic" = {
          fg = "orange";
          modifiers = ["italic"];
        };
        "markup.strikethrough" = {modifiers = ["crossed_out"];};
        "markup.link.url" = {
          fg = "orange";
          modifiers = ["underlined"];
        };
        "markup.link.text" = "yellow";
        "markup.quote" = "green";

        palette = {
          # primary colors
          "red" = "#${c.base08}";
          "orange" = "#${c.base09}";
          "yellow" = "#${c.base0A}";
          "green" = "#${c.base0B}";
          "blue" = "#${c.base0D}";
          "purple" = "#${c.base0E}";
          # base colors
          "base0" = "#${c.base00}";
          "base1" = "#${c.base01}";
          "base2" = "#${c.base02}";
          "base3" = "#${c.base03}";
          "base4" = "#${c.base04}";
          "base5" = "#${c.base05}";
          "base6" = "#${c.base06}";
          "base7" = "#${c.base07}";
          "base8" = "#${c.base07}";
          # variants
          "base8x0c" = "#${c.base07}";
        };
      };
    };
  };
}
