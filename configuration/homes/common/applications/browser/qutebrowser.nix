{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkForce;
in {
  home.sessionVariables.BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
  home.sessionVariables.DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
  home.persistence."/persist".directories = [
    ".local/share/qutebrowser"
    ".cache/qutebrowser"
    ".config/qutebrowser/bookmarks"
  ];
  mime.list = [
    {
      mimeTypes = [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
        "application/xhtml+xml"
      ];
      handler = "org.qutebrowser.qutebrowser.desktop";
    }
  ];

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
      base-16-themes = "https://tinted-theming.github.io/tinted-gallery/";

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
      DEFAULT = mkForce "https://ya.ru/search/?text={}";
      g = "https://www.google.com/search?hl=en&q={}";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      hm = "https://home-manager-options.extranix.com/?query={}&release=master";
      t = "https://translate.yandex.ru/?text={}"; # translate

      # nix (w)iki, (p)ackages, (o)ptions
      nw = "https://nixos.wiki/index.php?search={}&fulltext=1";
      np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      no = "https://search.nixos.org/options?channel=unstable&size=50&sort=relevance&type=packages&query={}";
    };
    keyBindings = {
      normal = let
        # theme for password selection
        rofi_theme = "${config.xdg.configHome}/qutebrowser/rofi/style-1.rasi";
        rofi_invokation = "--dmenu-invocation 'rofi -dmenu -theme ${rofi_theme}'";
        extract_login_from_secret = ''--username-target secret --username-pattern "login: (.+)"'';
        qute_pass_common_args = "--always-show-selection ${extract_login_from_secret} ${rofi_invokation}";
      in {
        "<Space>pp" = "spawn --userscript qute-pass ${qute_pass_common_args}";
        "<Space>pU" = "spawn --userscript qute-pass --username-only ${qute_pass_common_args}";
        "<Space>pP" = "spawn --userscript qute-pass --password-only ${qute_pass_common_args}";
        "<Space>pA" = "spawn --userscript qute-pass --unfiltered ${qute_pass_common_args}";
        "<Space>td" = "set colors.webpage.darkmode.enabled true;; set colors.webpage.preferred_color_scheme dark";
        "<Space>tl" = "set colors.webpage.darkmode.enabled false;; set colors.webpage.preferred_color_scheme light";
        "<Alt+d>" = "tab-next";
        "<Alt+a>" = "tab-prev";
        "<Ctrl+Alt+d>" = "tab-move +";
        "<Ctrl+Alt+a>" = "tab-move -";
        "<Alt+Left>" = "back";
        "<Alt+Right>" = "forward";
      };
    };
    settings = {
      # qt.highdpi = true;
      editor.command = let
        terminal = lib.getExe pkgs.kitty;
        editor = lib.getExe config.programs.helix.package;
      in [terminal "--class" "QuteTextEdit" "-e" editor "{file}" "+{line}"];
      tabs.show = "multiple";
      auto_save.session = true;
      session = {
        default_name = "${config.home.username}_session";
        lazy_restore = true;
      };
      tabs.last_close = "default-page";
      tabs.title.format = "{audio}{index}|{current_title}"; # original was ": " -> "|"
      input.spatial_navigation = true;
      fonts.default_family = mkForce config.stylix.fonts.serif.name;
      url = {
        start_pages = "file:///home/${config.home.username}/theme-preview.html";
        default_page = "qute://bookmarks/";
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
