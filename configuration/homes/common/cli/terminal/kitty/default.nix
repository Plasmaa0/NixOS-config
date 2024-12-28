{
  config,
  lib,
  ...
}: {
  home.persistence."/persist/home/${config.home.username}".directories = [".cache/kitty"];
  programs.kitty = {
    enable = true;
    font.size = lib.mkForce 20;
    keybindings = let
      mod = "ctrl+a";
    in {
      # tabs
      "${mod}>n" = "new_tab_with_cwd";
      "${mod}>N" = "new_tab";
      "${mod}>Q" = "close_tab";
      "${mod}>1" = "goto_tab 1";
      "${mod}>2" = "goto_tab 2";
      "${mod}>3" = "goto_tab 3";
      "${mod}>4" = "goto_tab 4";
      "${mod}>5" = "goto_tab 5";
      "${mod}>6" = "goto_tab 6";
      "${mod}>7" = "goto_tab 7";
      "${mod}>8" = "goto_tab 8";
      "${mod}>9" = "goto_tab 9";
      "${mod}>0" = "goto_tab 0";

      # splits
      "${mod}>\\" = "launch --location=vsplit --cwd=current";
      "${mod}>-" = "launch --location=hsplit --cwd=current";

      # close window
      "${mod}>q" = "close_window_with_confirmation ignore-shell";

      # resizing
      "${mod}>r" = "start_resizing_window";

      # switching windows
      "${mod}>left" = "neighboring_window left";
      "${mod}>right" = "neighboring_window right";
      "${mod}>up" = "neighboring_window up";
      "${mod}>down" = "neighboring_window down";
      "${mod}>s" = "focus_visible_window";
      "${mod}>space" = "nth_window -1";

      # moving windows
      "${mod}>shift+left" = "move_window left";
      "${mod}>shift+right" = "move_window right";
      "${mod}>shift+up" = "move_window up";
      "${mod}>shift+down" = "move_window down";

      # prev/next shell prompt
      "ctrl+up" = "scroll_to_prompt -1";
      "ctrl+down" = "scroll_to_prompt 1";
    };
    settings = {
      shell = "fish";
      enabled_layouts = "splits";
      visual_window_select_characters = "SADFGQWERZXCV";
      disable_ligatures = "never";
      font_features = "${config.stylix.fonts.monospace.name} +calt +clig +liga";
      tab_bar_edge = "top";
      tab_activity_symbol = "󱐋 ";
      tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{index}:{title}";
      window_padding_width = 10;
      single_window_padding_width = 10;
      window_border_width = "3pt";
    };
    shellIntegration.enableFishIntegration = true;
  };
}
