{...}: {
  flake.homeModules.cli-utils-elio = {
    pkgs,
    config,
    ...
  }: {
    home.packages = [(pkgs.callPackage ./_elio_package.nix {})];
    # home.persistence."/persist" = {
    #   directories = [
    #     ".config/opencode"
    #     ".cache/opencode"
    #     ".local/share/opencode"
    #     ".local/state/opencode"
    #   ];
    # };
    xdg.configFile."elio/theme.toml".source = let
      tomlFormat = pkgs.formats.toml {};
      c = config.lib.stylix.colors.withHashtag;
      theme = {
        palette = {
          bg = c.base00;
          chrome = c.base01;
          chrome_alt = c.base02;
          panel = c.base01;
          panel_alt = c.base02;
          surface = c.base03;
          elevated = c.base04;
          border = c.base05;
          text = c.base06;
          muted = c.base05;
          accent = c.base0D;
          accent_soft = c.base03;
          accent_text = c.base07;
          selected_bg = c.base04;
          selected_border = c.base0D;
          selection_bar = c.base09;
          yank_bar = c.base0B;
          cut_bar = c.base08;
          progress_bar = c.base0D;
          grid_selection_band = c.base0F;
          grid_yank_band = c.base0B;
          grid_cut_band = c.base08;
          sidebar_active = c.base03;
          button_bg = c.base00;
          button_disabled_bg = c.base01;
          path_bg = c.base00;
        };

        preview.code = {
          fg = c.base06;
          bg = c.base01;
          selection_bg = c.base03;
          selection_fg = c.base07;
          caret = c.base0D;
          line_highlight = c.base00;
          line_number = c.base04;
          comment = c.base03;
          string = c.base0B;
          constant = c.base09;
          keyword = c.base0E;
          function = c.base0D;
          type = c.base0A;
          parameter = c.base0F;
          tag = c.base0C;
          operator = c.base0C;
          macro = c.base08;
          invalid = c.base08;
        };

        classes = {
          directory = {color = c.base0D;};
          code = {color = c.base0C;};
          config = {color = c.base0E;};
          document = {color = c.base0B;};
          license = {color = c.base0A;};
          image = {color = c.base0C;};
          audio = {color = c.base09;};
          video = {color = c.base0E;};
          archive = {color = c.base08;};
          font = {color = c.base0E;};
          data = {color = c.base0B;};
          file = {color = c.base05;};
        };

        directories = {
          "node_modules" = {
            icon = "󰏗";
            color = c.base0D;
          };
          "tests" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "test" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "__tests__" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "scripts" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "build" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "dist" = {
            icon = "󰉋";
            color = c.base0D;
          };
          ".next" = {
            icon = "";
            color = c.base0D;
          };
          ".nuxt" = {
            icon = "󱄆";
            color = c.base0D;
          };
          ".svelte-kit" = {
            icon = "";
            color = c.base0D;
          };
          ".astro" = {
            icon = "";
            color = c.base0D;
          };
          "public" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "Public" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "publico" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "Publico" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "público" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "Público" = {
            icon = "󰉋";
            color = c.base0D;
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
            color = c.base0E;
          };
          "Music" = {
            icon = "󱍙";
            color = c.base0E;
          };
          "musica" = {
            icon = "󱍙";
            color = c.base0E;
          };
          "Musica" = {
            icon = "󱍙";
            color = c.base0E;
          };
          "música" = {
            icon = "󱍙";
            color = c.base0E;
          };
          "Música" = {
            icon = "󱍙";
            color = c.base0E;
          };
          "videos" = {
            icon = "󰕧";
            color = c.base0E;
          };
          "Videos" = {
            icon = "󰕧";
            color = c.base0E;
          };
          "vídeos" = {
            icon = "󰕧";
            color = c.base0E;
          };
          "Vídeos" = {
            icon = "󰕧";
            color = c.base0E;
          };
          "desktop" = {
            icon = "󰍹";
            color = c.base0E;
          };
          "Desktop" = {
            icon = "󰍹";
            color = c.base0E;
          };
          "escritorio" = {
            icon = "󰍹";
            color = c.base0E;
          };
          "Escritorio" = {
            icon = "󰍹";
            color = c.base0E;
          };
          "assets" = {
            icon = "󰉏";
            color = c.base0D;
          };
          "coverage" = {
            icon = "󰙨";
            color = c.base0D;
          };
          "tmp" = {
            icon = "󰪺";
            color = c.base0D;
          };
          "temp" = {
            icon = "󰪺";
            color = c.base0D;
          };
          "out" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "target" = {
            icon = "󱧽";
            color = c.base0D;
          };
          "bin" = {
            icon = "󱁿";
            color = c.base0D;
          };
          "lib" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "vendor" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "src" = {
            icon = "󰉋";
            color = c.base0D;
          };
          "config" = {
            icon = "󰒓";
            color = c.base0D;
          };
          "docs" = {
            icon = "󱧷";
            color = c.base0D;
          };
        };

        extensions = {
          toml = {
            class = "config";
            icon = "";
            color = c.base0E;
          };
          yaml = {
            class = "config";
            color = c.base0E;
          };
          yml = {
            class = "config";
            color = c.base0E;
          };
          json = {
            class = "config";
            icon = "";
            color = c.base0D;
          };
          jsonc = {
            class = "config";
            icon = "";
            color = c.base0D;
          };
          json5 = {
            class = "config";
            icon = "";
            color = c.base0D;
          };
          desktop = {
            class = "config";
            icon = "󰍹";
            color = c.base0D;
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
            color = c.base05;
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
            color = c.base0D;
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
            color = c.base05;
          };
          bash = {
            class = "code";
            icon = "";
            color = c.base05;
          };
          zsh = {
            class = "code";
            icon = "";
            color = c.base05;
          };
          fish = {
            class = "code";
            icon = "";
            color = c.base05;
          };
          c = {
            class = "code";
            icon = "";
            color = c.base0D;
          };
          cpp = {
            class = "code";
            icon = "";
            color = c.base0E;
          };
          h = {
            class = "code";
            icon = "";
            color = c.base0D;
          };
          hpp = {
            class = "code";
            icon = "";
            color = c.base0E;
          };
          java = {
            class = "code";
            icon = "";
            color = c.base08;
          };
          lua = {
            class = "code";
            icon = "";
            color = c.base0D;
          };
          php = {
            class = "code";
            icon = "";
            color = c.base0E;
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
            color = c.base0E;
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
            color = c.base0E;
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
            color = c.base0E;
          };
          xsd = {
            class = "code";
            icon = "󰗀";
            color = c.base0E;
          };
          xsl = {
            class = "code";
            icon = "󰗀";
            color = c.base0E;
          };
          xslt = {
            class = "code";
            icon = "󰗀";
            color = c.base0E;
          };
          css = {
            class = "code";
            icon = "";
            color = c.base0C;
          };
          scss = {
            class = "code";
            icon = "";
            color = c.base0F;
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
            color = c.base05;
          };
          sql = {
            class = "data";
            icon = "";
            color = c.base0B;
          };
          nix = {
            class = "config";
            icon = "";
            color = c.base0D;
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
            color = c.base05;
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
            color = c.base0D;
          };
          "package-lock.json" = {
            class = "data";
            icon = "󰈡";
            color = c.base0B;
          };
          "tsconfig.json" = {
            class = "config";
            icon = "";
            color = c.base0D;
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
            color = c.base0E;
          };
          "AUTHORS.md" = {
            class = "document";
            icon = "󰭘";
            color = c.base0E;
          };
          "AUTHORS.txt" = {
            class = "document";
            icon = "󰭘";
            color = c.base0E;
          };
          "CONTRIBUTORS" = {
            class = "document";
            icon = "󰭘";
            color = c.base0E;
          };
          "CONTRIBUTORS.md" = {
            class = "document";
            icon = "󰭘";
            color = c.base0E;
          };
          ".gitignore" = {
            class = "config";
            icon = "󰊢";
            color = c.base0E;
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
            color = c.base05;
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
            color = c.base0D;
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
            color = c.base0E;
          };
          "vite.config.js" = {
            class = "config";
            icon = "";
            color = c.base0E;
          };
          "vite.config.mjs" = {
            class = "config";
            icon = "";
            color = c.base0E;
          };
          "vite.config.mts" = {
            class = "config";
            icon = "";
            color = c.base0E;
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
            color = c.base0E;
          };
          "eslint.config.mjs" = {
            class = "config";
            icon = "󰱺";
            color = c.base0E;
          };
          "eslint.config.ts" = {
            class = "config";
            icon = "󰱺";
            color = c.base0E;
          };
          "prettier.config.js" = {
            class = "config";
            icon = "";
            color = c.base0F;
          };
          "prettier.config.mjs" = {
            class = "config";
            icon = "";
            color = c.base0F;
          };
          "prettier.config.ts" = {
            class = "config";
            icon = "";
            color = c.base0F;
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
            color = c.base0D;
          };
          "flake.nix" = {
            class = "config";
            icon = "";
            color = c.base0D;
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
