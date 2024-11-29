{ config, pkgs, ... }:

let
  c = config.lib.stylix.colors;
in 
{
  programs.helix = {
    enable = true;
    extraPackages = (with pkgs; [
      bash-language-server
      dockerfile-language-server-nodejs docker-compose-language-service
      yaml-language-server
      texlab
      clang-tools
      lua-language-server
      marksman
      nil
      python311Packages.python-lsp-server python312Packages.python-lsp-server black
      taplo
    ]);
  };
  home.file."${config.xdg.configHome}/helix" = {
    source = ./../dotfiles/helix;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/helix/themes/stylix.toml".text = ''
# Author : WindSoilder<WindSoilder@outlook.com>
# The unofficial Monokai Pro theme, simply migrate from jetbrains monokai pro theme: https://github.com/subtheme-dev/monokai-pro
# Credit goes to the original creator: https://monokai.pro

"ui.linenr.selected" = { bg = "base3" }
"ui.text.focus" = { fg = "yellow", modifiers= ["bold"] }
"ui.menu" = { fg = "base8", bg = "base3" }
"ui.menu.selected" = { fg = "base2", bg = "yellow" }
"ui.virtual.whitespace" = "base4"
"ui.virtual.ruler" = { bg = "base1" }
"ui.virtual.jump-label" = { fg = "red", modifiers = ["bold"] }

"info" = "base8"
"hint" = "base8"

# background color
"ui.background" = { bg = "base0" }

# status bars, panels, modals, autocompletion
"ui.statusline" = { fg = "base8", bg = "base2" }
"ui.statusline.inactive" = { fg = "base8", bg = "base1" }
"ui.popup" = { bg = "base3" }
"ui.window" = { bg = "base3" }
"ui.help" = { fg = "base8", bg = "base3" }

# active line, highlighting
"ui.selection" = { bg = "base4" }
"ui.cursor.match" = { bg = "base4" }
"ui.cursorline" = { bg = "base1" }

# bufferline, inlay hints
"ui.bufferline" = { fg = "base6", bg = "base8x0c" }
"ui.bufferline.active" = { fg = "base8", bg = "base4" }
"ui.virtual.inlay-hint" = { fg = "base6" }

# comments, nord3 based lighter color
"comment" = { fg = "base5", modifiers = ["italic"] }
"ui.linenr" = { fg = "base5" }

# cursor, variables, constants, attributes, fields
"ui.cursor.primary" = { fg = "base7", modifiers = ["reversed"] }
"attribute" = "blue"
"variable"  = "base8"
"constant"  = "orange"
"variable.builtin" = "red"
"constant.builtin" = "red"
"namespace" = "base8"

# base text, punctuation
"ui.text" = { fg = "base8" }
"punctuation" = "base4"

# classes, types, primitives
"type" = "green"
"type.builtin" = { fg = "red"}
"label" = "base8"

# declaration, methods, routines
"constructor" = "blue"
"function" = "green"
"function.macro" = { fg = "blue" }
"function.builtin" = { fg = "blue" }

# operator, tags, units, punctuations
"operator" = "red"
"variable.other.member" = "base8"

# keywords, special
"keyword" = { fg = "red" }
"keyword.directive" = "blue"
"variable.parameter" = "#f59762"

# error
"error" = { fg = "red", modifiers = ["bold"] }

# annotations, decorators
"special" = "#f59762"
"module" = "#f59762"

# warnings, escape characters, regex
"warning" = "orange"
"constant.character.escape" = { fg = "base8" }

# strings
"string" = "yellow"

# integer, floating point
"constant.numeric" = "purple"

# vcs
"diff.plus" = "green"
"diff.delta" = "orange"
"diff.minus" = "red"

# make diagnostic underlined, to distinguish with selection text.
"diagnostic.warning" = { underline = { color = "orange", style = "curl" } }
"diagnostic.error" = { underline = { color = "red", style = "curl" } }
"diagnostic.info" = { underline = { color = "base8", style = "curl" } }
"diagnostic.hint" = { underline = { color = "base8", style = "curl" } }
"diagnostic.unnecessary" = { modifiers = ["dim"] }
"diagnostic.deprecated" = { modifiers = ["crossed_out"] }

# markup highlight, no need for `markup.raw` and `markup.list`, make them to be default
"markup.heading" = "green"
"markup.bold" = { fg = "orange", modifiers = ["bold"] }
"markup.italic" = { fg = "orange", modifiers = ["italic"] }
"markup.strikethrough" = { modifiers = ["crossed_out"] }
"markup.link.url" = { fg = "orange", modifiers = ["underlined"] }
"markup.link.text" = "yellow"
"markup.quote" = "green"

[palette]
# primary colors
"red" = "#${c.base08}"
"orange" = "#${c.base09}"
"yellow" = "#${c.base0A}"
"green" = "#${c.base0B}"
"blue" = "#${c.base0D}"
"purple" = "#${c.base0E}"
# base colors
"base0" = "#${c.base00}"
"base1" = "#${c.base01}"
"base2" = "#${c.base02}"
"base3" = "#${c.base03}"
"base4" = "#${c.base04}"
"base5" = "#${c.base05}"
"base6" = "#${c.base06}"
"base7" = "#${c.base07}"
"base8" = "#${c.base07}"
# variants
"base8x0c" = "#${c.base07}"
'';
#     home.file."${config.xdg.configHome}/helix/themes/stylix.toml".text = ''
# "attributes" = "base08"
# "comment" = { fg = "base03", modifiers = ["italic"] }
# "constant" = "base08"
# "constant.character.escape" = "base0C"
# "constant.numeric" = "base09"
# "constructor" = "base0D"
# "debug" = "base03"
# "diagnostic" = { modifiers = ["underlined"] }
# "diff.delta" = "base09"
# "diff.minus" = "base08"
# "diff.plus" = "base0B"
# "error" = "base08"
# "function" = "base0D"
# "hint" = "base03"
# "info" = "base0D"
# "keyword" = "base0E"
# "label" = "base0E"
# "namespace" = "base0E"
# "operator" = "base09"
# "special" = "base0D"
# "string"  = "base0B"
# "type" = "base0A"
# "variable" = "base05"
# "variable.other.member" = "base08"
# "warning" = "base09"

# "markup.bold" = { fg = "base0A", modifiers = ["bold"] }
# "markup.heading" = "base0D"
# "markup.italic" = { fg = "base0E", modifiers = ["italic"] }
# "markup.link.text" = "base08"
# "markup.link.url" = { fg = "base09", modifiers = ["underlined"] }
# "markup.list" = "base08"
# "markup.quote" = "base0C"
# "markup.raw" = "base0B"
# "markup.strikethrough" = { modifiers = ["crossed_out"] }

# "diagnostic.hint" = { underline = { style = "curl" } }
# "diagnostic.info" = { underline = { style = "curl" } }
# "diagnostic.warning" = { underline = { style = "curl" } }
# "diagnostic.error" = { underline = { style = "curl" } }

# "ui.background" = { bg = "base00" }
# "ui.bufferline.active" = { fg = "base00", bg = "base03", modifiers = ["bold"] }
# "ui.bufferline" = { fg = "base04", bg = "base00" }
# "ui.cursor" = { fg = "base0A", modifiers = ["reversed"] }
# "ui.cursor.insert" = { fg = "base0A", modifiers = ["reversed"] }
# "ui.cursorline.primary" = { fg = "base05", bg = "base01" }
# "ui.cursor.match" = { fg = "base0A", modifiers = ["reversed"] }
# "ui.cursor.select" = { fg = "base0A", modifiers = ["reversed"] }
# "ui.gutter" = { bg = "base00" }
# "ui.help" = { fg = "base06", bg = "base01" }
# "ui.linenr" = { fg = "base03", bg = "base00" }
# "ui.linenr.selected" = { fg = "base04", bg = "base01", modifiers = ["bold"] }
# "ui.menu" = { fg = "base05", bg = "base01" }
# "ui.menu.scroll" = { fg = "base03", bg = "base01" }
# "ui.menu.selected" = { fg = "base01", bg = "base04" }
# "ui.popup" = { bg = "base01" }
# "ui.selection" = { bg = "base02" }
# "ui.selection.primary" = { bg = "base02" }
# "ui.statusline" = { fg = "base04", bg = "base01" }
# "ui.statusline.inactive" = { bg = "base01", fg = "base03" }
# "ui.statusline.insert" = { fg = "base00", bg = "base0B" }
# "ui.statusline.normal" = { fg = "base00", bg = "base03" }
# "ui.statusline.select" = { fg = "base00", bg = "base0F" }
# "ui.text" = "base05"
# "ui.text.focus" = "base05"
# "ui.virtual.indent-guide" = { fg = "base03" }
# "ui.virtual.inlay-hint" = { fg = "base03" }
# "ui.virtual.ruler" = { bg = "base01" }
# "ui.virtual.jump-label" = { fg = "base0A", modifiers = ["bold"] }
# "ui.window" = { bg = "base01" }

# [palette]
# base00 = "#${c.base00}" # Default Background
# base01 = "#${c.base01}" # Lighter Background (Used for status bars, line number and folding marks)
# base02 = "#${c.base02}" # Selection Background
# base03 = "#${c.base03}" # Comments, Invisibles, Line Highlighting
# base04 = "#${c.base04}" # Dark Foreground (Used for status bars)
# base05 = "#${c.base05}" # Default Foreground, Caret, Delimiters, Operators
# base06 = "#${c.base06}" # Light Foreground (Not often used)
# base07 = "#${c.base07}" # Light Background (Not often used)
# base08 = "#${c.base08}" # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
# base09 = "#${c.base09}" # Integers, Boolean, Constants, XML Attributes, Markup Link Url
# base0A = "#${c.base0A}" # Classes, Markup Bold, Search Text Background
# base0B = "#${c.base0B}" # Strings, Inherited Class, Markup Code, Diff Inserted
# base0C = "#${c.base0C}" # Support, Regular Expressions, Escape Characters, Markup Quotes
# base0D = "#${c.base0D}" # Functions, Methods, Attribute IDs, Headings
# base0E = "#${c.base0E}" # Keywords, Storage, Selector, Markup Italic, Diff Changed
# base0F = "#${c.base0F}" # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
#   '';
}
