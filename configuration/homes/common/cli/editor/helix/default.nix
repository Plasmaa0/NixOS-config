{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
in {
  home.persistence."/persist/home/${config.home.username}".directories = [".cache/helix"];
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      bash-language-server
      dockerfile-language-server-nodejs
      docker-compose-language-service
      yaml-language-server
      texlab
      zathura
      clang-tools
      lua-language-server
      marksman
      markdown-oxide
      nil
      python311Packages.python-lsp-server
      python312Packages.python-lsp-server
      black
      mypy
      basedpyright
      ruff
      taplo
      alejandra
    ];

    settings = {
      theme = "stylix";
      editor = {
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
      keys = {
        normal = {
          C-e = "page_cursor_half_up";
          C-r = ":config-reload";
          C-s = ":w";
          A-j = ["search_selection" "extend_search_next"];
          C-q = ":bc";
          C-A-l = ":format";
          C-o = ":open ~/.config/helix/config.toml";
          esc = ["collapse_selection" "keep_primary_selection"];
          ret = ["open_below" "normal_mode"];
          S-up = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
          S-down = ["extend_to_line_bounds" "delete_selection" "paste_after"];
          C-left = ["jump_backward"];
          C-right = ["jump_forward"];
          space.space = "goto_word";
        };
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          auto-pairs = {
            "=" = ";";
          };
          auto-format = true;
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          formatter = {
            command = "alejandra";
            args = ["-qq" "-"];
          };
        }
        {
          name = "python";
          auto-format = true;
          language-servers = ["ruff" "pylsp"];
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }
        {
          name = "latex";
          formatter = {
            command = "prettier";
            args = ["--parser" "latex-parser"];
          };
          auto-format = true;
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }
      ];
      language-server = {
        nil.config.nil = {
          formatting.command = ["alejandra -qq -"];
          nix = {
            maxMemoryMB = 4096;
            flake = {
              autoArchive = true;
              autoEvalInputs = true;
            };
          };
        };
        pylsp.config.pylsp.plugins.pylsp_mypy = {
          enabled = true;
          live_mode = true;
        };
        basedpyright.config.basedpyright.analysis.typeCheckingMode = "recommended";
        ruff = {
          command = "ruff";
          args = ["server"];
          environment.RUFF_TRACE = "messages";
          config.settings = {
            logLevel = "debug";
            lineLength = 88;
            indent-width = 4;
            lint = {
              select = ["ALL"];
              ignore = ["INP001" "ERA001" "D1" "ANN" "COM" "T20"];
            };
          };
        };

        texlab.config.texlab = {
          auxDirectory = "build";
          chktex = {
            onOpenAndSave = true;
            onEdit = true;
          };
          forwardSearch = {
            executable = "zathura";
            args = ["--synctex-forward" "%l:%c:%f" "%p"];
          };
          build = {
            forwardSearchAfter = true;
            onSave = true;
            executable = "latexmk";
            args = ["-pdf" "-interaction=nonstopmode" "-synctex=1" "-shell-escape" "-output-directory=build" "%f"];
          };
        };
      };
    };
    themes = {
      stylix = {
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
          bg = "base8x0c";
        };
        "ui.bufferline.active" = {
          fg = "base8";
          bg = "base4";
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
