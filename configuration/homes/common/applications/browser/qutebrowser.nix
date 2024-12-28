{
  config,
  pkgs,
  lib,
  ...
}: let
  # theme for password selection
  # rofi_theme = ../dotfiles/rofi/launchers/type-2/style-1.rasi;
  rofi_theme = "${config.xdg.configHome}/qutebrowser/rofi/style-1.rasi";
  qute_pass_common_args = "--always-show-selection --dmenu-invocation 'rofi -dmenu -theme ${rofi_theme}'";
in {
  home.sessionVariables.BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
  home.sessionVariables.DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
  home.persistence."/persist/home/${config.home.username}".directories = [
    ".local/share/qutebrowser"
    ".cache/qutebrowser"
    ".config/qutebrowser/bookmarks"
  ];
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = ["org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/http" = ["org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/https" = ["org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/about" = ["org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/unknown" = ["org.qutebrowser.qutebrowser.desktop"];
    };
  };
  home.sessionVariables = {
    PASSWORD_STORE_DIR = "$HOME/.password-store";
  };
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (ext: with ext; [pass-import]);
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
  };
  programs.rofi.pass = {
    enable = true;
    stores = ["$HOME/.password-store"];
  };
  home.file."${config.xdg.configHome}/qutebrowser/rofi" = {
    source = ../../desktop/common/rofi/rofi/launchers/type-2;
    recursive = true;
  };
  programs.qutebrowser = {
    enable = true;
    quickmarks = {
      # nix(os)
      home-manager = "https://nix-community.github.io/home-manager/options.xhtml";
      stylix = "https://stylix.danth.me/options/nixos.html";
      cheatsheet = "https://raw.githubusercontent.com/qutebrowser/qutebrowser/main/doc/img/cheatsheet-big.png";
      base-16-themes = "https://tinted-theming.github.io/base16-gallery/";

      # social
      music = "https://next.music.yandex.ru";
      reddit = "https://www.reddit.com";
      vk = "https://vk.com/im";

      # education
      lks = "https://lks.bmstu.ru";
      eu = "https://eu.bmstu.ru";
      samoware-student = "https://student.bmstu.ru";
      samoware-work = "https://mail.bmstu.ru";

      # code
      github-gh = "https://github.com/${config.home.username}?tab=repositories";
    };
    searchEngines = {
      DEFAULT = lib.mkForce "https://ya.ru/search/?text={}";
      g = "https://www.google.com/search?hl=en&q={}";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";

      # nix (w)iki, (p)ackages, (o)ptions
      nw = "https://wiki.nixos.org/index.php?search={}";
      np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      no = "https://search.nixos.org/options?channel=unstable&size=50&sort=relevance&type=packages&query={}";
    };
    keyBindings = {
      normal = {
        "<Space>pp" = "spawn --userscript qute-pass ${qute_pass_common_args}";
        "<Space>pU" = "spawn --userscript qute-pass --username-only ${qute_pass_common_args}";
        "<Space>pP" = "spawn --userscript qute-pass --password-only ${qute_pass_common_args}";
        "<Space>pA" = "spawn --userscript qute-pass --unfiltered ${qute_pass_common_args}";
        "<Space>td" = "set colors.webpage.darkmode.enabled true;; set colors.webpage.preferred_color_scheme dark";
        "<Space>tl" = "set colors.webpage.darkmode.enabled false;; set colors.webpage.preferred_color_scheme light";
        "<Alt+d>" = "tab-next";
        "<Alt+a>" = "tab-prev";
        "<Alt+Left>" = "back";
        "<Alt+Right>" = "forward";
      };
    };
    settings = {
      zoom.default = "200%";
      qt = {
        highdpi = true;
      };
      # tabs.position = "left";
      # scrolling.smooth = true;
      # auto_save.session = true;
      session = {
        default_name = "${config.home.username}_session";
        lazy_restore = true;
      };
      tabs.last_close = "blank";
      input.spatial_navigation = true;
      fonts = {
        default_size = lib.mkForce "24pt";
        default_family = lib.mkForce config.stylix.fonts.serif.name;
        # web.size = {
        # 	default = lib.mkForce 24;
        # 	default_fixed = lib.mkForce 20;
        # };
      };
      url = {
        start_pages = "about:blank"; # "https://ya.ru";
        default_page = "https://ya.ru";
      };
      completion = {
        open_categories = [
          "searchengines"
          "quickmarks"
          "bookmarks"
          "filesystem"
          "history"
        ];
        favorite_paths = [
          "~/"
        ];
      };
    };
  };
}
