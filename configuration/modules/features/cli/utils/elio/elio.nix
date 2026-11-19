{...}: {
  flake.homeModules.cli-utils-elio = {
    config,
    inputs,
    pkgs,
    ...
  }: let
    elio = inputs.elio.packages.${pkgs.stdenv.hostPlatform.system}.default;
    tomlFormat = pkgs.formats.toml {};
    c = config.lib.stylix.colors.withHashtag;
  in {
    home.packages = [elio];

    xdg.dataFile = {
      "xdg-desktop-portal/portals/elio.portal".text = ''
        [portal]
        DBusName=io.github.elio_fm.elio.Portal
        Interfaces=org.freedesktop.impl.portal.FileChooser;
      '';
      "dbus-1/services/io.github.elio_fm.elio.Portal.service".text = ''
        [D-BUS Service]
        Name=io.github.elio_fm.elio.Portal
        Exec=${config.home.profileDirectory}/bin/elio --portal-service
      '';
    };

    xdg.configFile."elio/config.toml".source = tomlFormat.generate "elio-config.toml" {
      portal.terminal = "kitty";
    };

    xdg.configFile."elio/theme.toml".source = let
      theme = {
        palette = {
          bg = c.base00;
          chrome = c.base01;
          chrome_alt = c.base02;
          panel = c.base01;
          panel_alt = c.base02;
          surface = c.base02;
          elevated = c.base03;
          border = c.base04;
          text = c.base07;
          muted = c.base04;
          colored_names = true;
          accent = c.base0C;
          accent_soft = c.base02;
          accent_text = c.base00;
          selected_bg = c.base02;
          chip_text = c.base00;
          selected_border = c.base0C;
          selection_bar = c.base09;
          yank_bar = c.base0B;
          cut_bar = c.base08;
          progress_bar = c.base0C;
          trash_bar = c.base08;
          restore_bar = c.base0C;
          sidebar_active = c.base02;
          button_bg = c.base01;
          button_disabled_bg = c.base00;
          path_bg = c.base00;
        };

        preview.code = {
          fg = c.base07;
          bg = c.base00;
          selection_bg = c.base02;
          selection_fg = c.base07;
          caret = c.base0C;
          line_highlight = c.base01;
          line_number = c.base04;
          comment = c.base04;
          string = c.base0B;
          constant = c.base09;
          keyword = c.base0E;
          function = c.base0C;
          type = c.base0A;
          parameter = c.base0F;
          tag = c.base0C;
          operator = c.base0D;
          macro = c.base08;
          invalid = c.base08;
        };

        classes = {
          directory = {color = c.base0C;};
          symlink_directory = {color = c.base0C;};
          broken_symlink = {color = c.base08;};
          code = {color = c.base0A;};
          config = {color = c.base0E;};
          document = {color = c.base0B;};
          license = {color = c.base0F;};
          image = {color = c.base09;};
          audio = {color = c.base0D;};
          video = {color = c.base0A;};
          archive = {color = c.base08;};
          font = {color = c.base0E;};
          data = {color = c.base0B;};
          file = {color = c.base07;};
        };

        directories = {
          "node_modules" = {
            icon = "󰏗";
            color = c.base0C;
          };
          "tests" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "test" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "__tests__" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "scripts" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "build" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "dist" = {
            icon = "󰉋";
            color = c.base0C;
          };
          ".next" = {
            icon = "";
            color = c.base0C;
          };
          ".nuxt" = {
            icon = "󱄆";
            color = c.base0C;
          };
          ".svelte-kit" = {
            icon = "";
            color = c.base0C;
          };
          ".astro" = {
            icon = "";
            color = c.base0C;
          };
          "public" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "Public" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "publico" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "Publico" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "público" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "Público" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "pictures" = {
            icon = "󰉏";
            color = c.base0C;
          };
          "Pictures" = {
            icon = "󰉏";
            color = c.base0C;
          };
          "imagenes" = {
            icon = "󰉏";
            color = c.base0C;
          };
          "Imagenes" = {
            icon = "󰉏";
            color = c.base0C;
          };
          "imágenes" = {
            icon = "󰉏";
            color = c.base0C;
          };
          "Imágenes" = {
            icon = "󰉏";
            color = c.base0C;
          };
          "documents" = {
            icon = "󰲃";
            color = c.base0B;
          };
          "Documents" = {
            icon = "󰲃";
            color = c.base0B;
          };
          "documentos" = {
            icon = "󰲃";
            color = c.base0B;
          };
          "Documentos" = {
            icon = "󰲃";
            color = c.base0B;
          };
          "downloads" = {
            icon = "󰉍";
            color = c.base0A;
          };
          "Downloads" = {
            icon = "󰉍";
            color = c.base0A;
          };
          "descargas" = {
            icon = "󰉍";
            color = c.base0A;
          };
          "Descargas" = {
            icon = "󰉍";
            color = c.base0A;
          };
          "music" = {
            icon = "󱍙";
            color = c.base0A;
          };
          "Music" = {
            icon = "󱍙";
            color = c.base0A;
          };
          "musica" = {
            icon = "󱍙";
            color = c.base0A;
          };
          "Musica" = {
            icon = "󱍙";
            color = c.base0A;
          };
          "música" = {
            icon = "󱍙";
            color = c.base0A;
          };
          "Música" = {
            icon = "󱍙";
            color = c.base0A;
          };
          "videos" = {
            icon = "󰕧";
            color = c.base0A;
          };
          "Videos" = {
            icon = "󰕧";
            color = c.base0A;
          };
          "vídeos" = {
            icon = "󰕧";
            color = c.base0A;
          };
          "Vídeos" = {
            icon = "󰕧";
            color = c.base0A;
          };
          "desktop" = {
            icon = "󰍹";
            color = c.base0A;
          };
          "Desktop" = {
            icon = "󰍹";
            color = c.base0A;
          };
          "escritorio" = {
            icon = "󰍹";
            color = c.base0A;
          };
          "Escritorio" = {
            icon = "󰍹";
            color = c.base0A;
          };
          "assets" = {
            icon = "󰉏";
            color = c.base0C;
          };
          "coverage" = {
            icon = "󰙨";
            color = c.base0C;
          };
          "tmp" = {
            icon = "󰪺";
            color = c.base0C;
          };
          "temp" = {
            icon = "󰪺";
            color = c.base0C;
          };
          "out" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "target" = {
            icon = "󱧽";
            color = c.base0C;
          };
          "bin" = {
            icon = "󱁿";
            color = c.base0C;
          };
          "lib" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "vendor" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "src" = {
            icon = "󰉋";
            color = c.base0C;
          };
          "config" = {
            icon = "󰒓";
            color = c.base0C;
          };
          "docs" = {
            icon = "󱧷";
            color = c.base0C;
          };
        };

        extensions = {
          toml = {
            class = "config";
            icon = "";
            color = c.base0A;
          };
          yaml = {
            class = "config";
            color = c.base0A;
          };
          yml = {
            class = "config";
            color = c.base0A;
          };
          json = {
            class = "config";
            icon = "";
            color = c.base0C;
          };
          jsonc = {
            class = "config";
            icon = "";
            color = c.base0C;
          };
          json5 = {
            class = "config";
            icon = "";
            color = c.base0C;
          };
          desktop = {
            class = "config";
            icon = "󰍹";
            color = c.base0C;
          };
          xcf = {
            class = "image";
            icon = "";
            color = c.base08;
          };
          pdf = {
            class = "document";
            icon = "󰈙";
            color = c.base08;
          };
          epub = {
            class = "document";
            icon = "󱗖";
            color = c.base0A;
          };
          cbz = {
            class = "archive";
            icon = "󱗖";
            color = c.base0A;
          };
          cbr = {
            class = "archive";
            icon = "󱗖";
            color = c.base0A;
          };
          ico = {
            class = "image";
            icon = "󰋩";
            color = c.base0C;
          };
          iso = {
            class = "archive";
            icon = "󰗮";
            color = c.base08;
          };
          lock = {
            class = "data";
            icon = "󰈡";
            color = c.base0B;
          };
          rs = {
            class = "code";
            icon = "";
            color = c.base09;
          };
          ts = {
            class = "code";
            icon = "";
            color = c.base0C;
          };
          tsx = {
            class = "code";
            icon = "󰜈";
            color = c.base0C;
          };
          js = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          jsx = {
            class = "code";
            icon = "󰜈";
            color = c.base09;
          };
          py = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          go = {
            class = "code";
            icon = "";
            color = c.base0C;
          };
          sh = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          bash = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          zsh = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          fish = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          c = {
            class = "code";
            icon = "";
            color = c.base0C;
          };
          cpp = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          h = {
            class = "code";
            icon = "";
            color = c.base0C;
          };
          hpp = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          java = {
            class = "code";
            icon = "";
            color = c.base08;
          };
          lua = {
            class = "code";
            icon = "";
            color = c.base0C;
          };
          php = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          rb = {
            class = "code";
            icon = "";
            color = c.base08;
          };
          swift = {
            class = "code";
            icon = "";
            color = c.base09;
          };
          kt = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          vue = {
            class = "code";
            icon = "";
            color = c.base0B;
          };
          svelte = {
            class = "code";
            icon = "";
            color = c.base09;
          };
          astro = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          html = {
            class = "code";
            icon = "";
            color = c.base08;
          };
          htm = {
            class = "code";
            icon = "";
            color = c.base08;
          };
          xml = {
            class = "code";
            icon = "󰗀";
            color = c.base0A;
          };
          xsd = {
            class = "code";
            icon = "󰗀";
            color = c.base0A;
          };
          xsl = {
            class = "code";
            icon = "󰗀";
            color = c.base0A;
          };
          xslt = {
            class = "code";
            icon = "󰗀";
            color = c.base0A;
          };
          css = {
            class = "code";
            icon = "";
            color = c.base0C;
          };
          scss = {
            class = "code";
            icon = "";
            color = c.base09;
          };
          md = {
            class = "document";
            icon = "";
            color = c.base0A;
          };
          markdown = {
            class = "document";
            icon = "";
            color = c.base0A;
          };
          mdown = {
            class = "document";
            icon = "";
            color = c.base0A;
          };
          mkd = {
            class = "document";
            icon = "";
            color = c.base0A;
          };
          mdx = {
            class = "document";
            icon = "";
            color = c.base0A;
          };
          qmd = {
            class = "document";
            icon = "";
            color = c.base0A;
          };
          txt = {
            class = "document";
            icon = "";
            color = c.base0B;
          };
          sql = {
            class = "data";
            icon = "";
            color = c.base0B;
          };
          nix = {
            class = "config";
            icon = "";
            color = c.base0C;
          };
          dart = {
            class = "code";
            icon = "";
            color = c.base0C;
          };
          zig = {
            class = "code";
            icon = "";
            color = c.base0A;
          };
          log = {
            class = "document";
            icon = "";
            color = c.base0B;
          };
          srt = {
            class = "document";
            icon = "󰈙";
            color = c.base0B;
          };
        };

        files = {
          "Cargo.lock" = {
            class = "data";
            icon = "󰈡";
            color = c.base0B;
          };
          "package.json" = {
            class = "config";
            icon = "󰏗";
            color = c.base0C;
          };
          "package-lock.json" = {
            class = "data";
            icon = "󰈡";
            color = c.base0B;
          };
          "tsconfig.json" = {
            class = "config";
            icon = "";
            color = c.base0C;
          };
          "Dockerfile" = {
            class = "config";
            icon = "󰡨";
            color = c.base0C;
          };
          "compose.yml" = {
            class = "config";
            icon = "󰡨";
            color = c.base0C;
          };
          "compose.yaml" = {
            class = "config";
            icon = "󰡨";
            color = c.base0C;
          };
          "docker-compose.yml" = {
            class = "config";
            icon = "󰡨";
            color = c.base0C;
          };
          "docker-compose.yaml" = {
            class = "config";
            icon = "󰡨";
            color = c.base0C;
          };
          "README.md" = {
            class = "document";
            icon = "";
            color = c.base0A;
          };
          "AUTHORS" = {
            class = "document";
            icon = "󰭘";
            color = c.base0A;
          };
          "AUTHORS.md" = {
            class = "document";
            icon = "󰭘";
            color = c.base0A;
          };
          "AUTHORS.txt" = {
            class = "document";
            icon = "󰭘";
            color = c.base0A;
          };
          "CONTRIBUTORS" = {
            class = "document";
            icon = "󰭘";
            color = c.base0A;
          };
          "CONTRIBUTORS.md" = {
            class = "document";
            icon = "󰭘";
            color = c.base0A;
          };
          ".gitignore" = {
            class = "config";
            icon = "󰊢";
            color = c.base0A;
          };
          ".env" = {
            class = "config";
            icon = "󰒓";
            color = c.base0B;
          };
          ".npmrc" = {
            class = "config";
            icon = "";
            color = c.base08;
          };
          ".yarnrc.yml" = {
            class = "config";
            icon = "";
            color = c.base0C;
          };
          "pnpm-lock.yaml" = {
            class = "data";
            icon = "󰈡";
            color = c.base09;
          };
          "yarn.lock" = {
            class = "data";
            icon = "󰈡";
            color = c.base0C;
          };
          "bun.lock" = {
            class = "data";
            icon = "󰈡";
            color = c.base0A;
          };
          "bun.lockb" = {
            class = "data";
            icon = "󰈡";
            color = c.base0A;
          };
          "pnpm-workspace.yaml" = {
            class = "config";
            icon = "";
            color = c.base09;
          };
          "biome.json" = {
            class = "config";
            icon = "󰏗";
            color = c.base0C;
          };
          "turbo.json" = {
            class = "config";
            icon = "󰐷";
            color = c.base0E;
          };
          "deno.json" = {
            class = "config";
            icon = "";
            color = c.base0B;
          };
          "deno.jsonc" = {
            class = "config";
            icon = "";
            color = c.base0B;
          };
          "poetry.lock" = {
            class = "data";
            icon = "󰈡";
            color = c.base0B;
          };
          "requirements.txt" = {
            class = "document";
            icon = "";
            color = c.base0C;
          };
          "go.mod" = {
            class = "config";
            icon = "";
            color = c.base0C;
          };
          "go.sum" = {
            class = "data";
            icon = "";
            color = c.base0B;
          };
          "vite.config.ts" = {
            class = "config";
            icon = "";
            color = c.base0A;
          };
          "vite.config.js" = {
            class = "config";
            icon = "";
            color = c.base0A;
          };
          "vite.config.mjs" = {
            class = "config";
            icon = "";
            color = c.base0A;
          };
          "vite.config.mts" = {
            class = "config";
            icon = "";
            color = c.base0A;
          };
          "tailwind.config.ts" = {
            class = "config";
            icon = "󱏿";
            color = c.base0C;
          };
          "tailwind.config.js" = {
            class = "config";
            icon = "󱏿";
            color = c.base0C;
          };
          "tailwind.config.mjs" = {
            class = "config";
            icon = "󱏿";
            color = c.base0C;
          };
          "eslint.config.js" = {
            class = "config";
            icon = "󰱺";
            color = c.base0A;
          };
          "eslint.config.mjs" = {
            class = "config";
            icon = "󰱺";
            color = c.base0A;
          };
          "eslint.config.ts" = {
            class = "config";
            icon = "󰱺";
            color = c.base0A;
          };
          "prettier.config.js" = {
            class = "config";
            icon = "";
            color = c.base09;
          };
          "prettier.config.mjs" = {
            class = "config";
            icon = "";
            color = c.base09;
          };
          "prettier.config.ts" = {
            class = "config";
            icon = "";
            color = c.base09;
          };
          "postcss.config.js" = {
            class = "config";
            icon = "";
            color = c.base0C;
          };
          "postcss.config.cjs" = {
            class = "config";
            icon = "";
            color = c.base0C;
          };
          "jest.config.js" = {
            class = "config";
            icon = "󰙨";
            color = c.base0A;
          };
          "jest.config.ts" = {
            class = "config";
            icon = "󰙨";
            color = c.base0A;
          };
          "vitest.config.ts" = {
            class = "config";
            icon = "󰙨";
            color = c.base0B;
          };
          "CMakeLists.txt" = {
            class = "config";
            icon = "";
            color = c.base0C;
          };
          "flake.nix" = {
            class = "config";
            icon = "";
            color = c.base0C;
          };
          "flake.lock" = {
            class = "data";
            icon = "󰈡";
            color = c.base0B;
          };
        };
      };
    in
      tomlFormat.generate "elio-theme.toml" theme;
  };
}
