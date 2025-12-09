{
  pkgs,
  config,
  ...
}: {
  home.persistence."/persist/home/${config.home.username}" = {
    directories = ["~/.cache/albert" "~/.local/share/albert"];
  };
  systemd.user.services.albert = {
    Unit = {
      Description = "Albert - fast and flexible keyboard launcher";
      PartOf = ["tray.target"];
    };
    Service = {
      Type = "forking";
      Environment = ["PATH=${pkgs.albert}/bin:/run/wrappers/bin"];
      ExecStart = let
        scriptPkg =
          pkgs.writeShellScriptBin "albert-start"
          # bash
          ''
            albert &
          '';
      in "${scriptPkg}/bin/albert-start";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["tray.target"];
    };
  };
  xdg.configFile."albert/config".text =
    # ini
    ''
      [General]
      frontend=widgetsboxmodel
      telemetry=true

      [applications]
      enabled=true
      fuzzy=true
      terminal=kitty
      use_exec=true
      use_generic_name=true
      use_keywords=true

      [calculator_qalculate]
      enabled=true
      units_in_global_query=true
      functions_in_global_query=true

      [timer]
      enabled=true

      [urlhandler]
      enabled=true

      [websearch]
      enabled=true

      [datetime]
      enabled=true

      [files]
      enabled=true
      fuzzy=true
      global_handler_enabled=true
      home\${config.home.username}\followSymlinks=false
      home\${config.home.username}\indexhidden=false
      home\${config.home.username}\maxDepth=255
      home\${config.home.username}\mimeFilters=inode/directory, application/*, audio/*, video/*, image/*
      home\${config.home.username}\nameFilters=@Invalid()
      home\${config.home.username}\scanInterval=20
      home\${config.home.username}\useFileSystemWatches=false
      paths=/home/${config.home.username}

      [widgetsboxmodel]
      alwaysOnTop=true
      clearOnHide=false
      clientShadow=false
      displayScrollbar=false
      followCursor=true
      hideOnFocusLoss=true
      historySearch=true
      itemCount=5
      quitOnClose=false
      showCentered=true
      systemShadow=true

      [widgetsboxmodel-ng]
      alwaysOnTop=true
      clearOnHide=true
      clientShadow=false
      darkTheme=
      debug=false
      displayScrollbar=true
      followCursor=true
      hideOnFocusLoss=true
      historySearch=true
      itemCount=5
      lightTheme=
      quitOnClose=true
      showCentered=true
    '';
  xdg.configFile."albert/websearch/engines.json".text = let
    theme = {
      inherit (config.gtk.iconTheme) package;
      inherit (config.gtk.iconTheme) name;
    };
    icon = path: "${theme.package}/share/icons/${theme.name}/64x64/${path}.svg";
  in
    builtins.toJSON [
      {
        fallback = true;
        iconPath = icon "apps/yandex-browser";
        name = "Yandex";
        trigger = "ya";
        url = "https://ya.ru/search/?text=%s";
      }
      {
        fallback = false;
        iconPath = icon "apps/google";
        name = "Google";
        trigger = "g";
        url = "https://www.google.com/search?hl=en&q=%s";
      }
      {
        fallback = false;
        iconPath = icon "apps/nix-snowflake";
        name = "hm";
        trigger = "hm";
        url = "https://home-manager-options.extranix.com/?query=%s&release=master";
      }
      {
        fallback = false;
        iconPath = icon "apps/nix-snowflake";
        name = "no";
        trigger = "no";
        url = "https://search.nixos.org/options?channel=unstable&size=50&sort=relevance&type=packages&query=%s";
      }
      {
        fallback = false;
        iconPath = icon "apps/nix-snowflake";
        name = "np";
        trigger = "np";
        url = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=%s";
      }
      {
        fallback = false;
        iconPath = icon "apps/nix-snowflake";
        name = "nw";
        trigger = "nw";
        url = "https://nixos.wiki/index.php?search=%s&fulltext=1";
      }
      {
        fallback = true;
        iconPath = icon "apps/google-translate";
        name = "t";
        trigger = "t";
        url = "https://translate.yandex.ru/?text=%s";
      }
      {
        fallback = true;
        iconPath = icon "apps/wikipedia";
        name = "w";
        trigger = "w";
        url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go&ns0=1";
      }
      {
        fallback = false;
        iconPath = icon "apps/maps";
        name = "Yandex Maps";
        trigger = "maps";
        url = "https://yandex.ru/maps/?mode=search&text=%s";
      }
      {
        fallback = false;
        iconPath = icon "apps/bookreader";
        name = "Google Scholar";
        trigger = "scholar";
        url = "https://scholar.google.com/scholar?q=%s";
      }
      {
        fallback = false;
        iconPath = icon "apps/gnome-translate";
        name = "Google Translate";
        trigger = "gt";
        url = "https://translate.google.com/?text=%s";
      }
      {
        fallback = true;
        iconPath = icon "apps/wolfram-mathematica";
        name = "Wolfram Alpha";
        trigger = "wa";
        url = "https://www.wolframalpha.com/input/?i=%s";
      }
      {
        fallback = true;
        iconPath = icon "apps/youtube";
        name = "YouTube";
        trigger = "yt";
        url = "https://www.youtube.com/results?search_query=%s";
      }
    ];
}
