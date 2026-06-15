# Dendritic Nix Configuration — Full Reference

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Build Instructions](#build-instructions)
3. [Dendritic Pattern Reference](#dendritic-pattern-reference)
4. [Complete File Inventory](#complete-file-inventory)
5. [Conventions](#conventions)
6. [How To: Add / Modify / Remove](#how-to-add--modify--remove)
7. [What Has Been Done](#what-has-been-done)
8. [Transition Procedure](#transition-procedure)
9. [Troubleshooting & Pitfalls](#troubleshooting--pitfalls)

---

## Architecture Overview

This is a NixOS + home-manager configuration managed as a **dendritic flake-parts** tree.  
Reference implementation: `/home/plasmaa0/infa/repos/nixconf`

### Key Concepts

| Concept | Meaning |
|---------|---------|
| **Dendritic** | Every `.nix` file (except entry points) is a flake-parts module. Files export under `flake.*` keys. Flake-parts merges all `flake` attributes → multiple files can write to the same key. |
| **`importTree`** | Custom function using `lib.fileset.fileFilter` to recursively find all `.nix` files (excluding `_*` and `flake.nix`) and pass them as `imports` to `mkFlake`. |
| **`_` prefix** | Files starting with `_` are NOT auto-imported. They are split sub-modules manually imported by their parent module. |
| **Grouped keys** | HM modules in the same directory share a `flake.homeModules.*` key (e.g., all files under `applications/` → `flake.homeModules.applications`). |
| **`self`** | The final flake output. Available in all modules via `specialArgs`/`extraSpecialArgs`. Used to reference other modules: `self.nixosModules.*`, `self.homeModules.*`. |

### Data Flow

```
flake-new.nix (entry point)
  │  importTree(./modules) discovers all .nix files
  │
  └─ mkFlake { imports = [ all discovered files ] }
       │
       ├─ parts.nix  →  sets systems, pkgs config, imports home-manager flake module
       │
       ├─ nixos/*    →  export flake.nixosModules.*
       │    ├─ nb.nix → also exports flake.nixosConfigurations.nb
       │    ├─ zep.nix → also exports flake.nixosConfigurations.zep
       │    ├─ stylix.nix → also exports flake.homeModules.stylix
       │    └─ common/* → 28 individual NixOS feature modules
       │
       └─ home/*     →  export flake.homeModules.*
            ├─ plasmaa0.nix → user entry, imports 9 grouped HM modules
            ├─ common.nix, secrets.nix, shell-templates/
            ├─ cli/  → 13 files → flake.homeModules.cli
            ├─ desktop/ → 8 files → flake.homeModules.desktop
            ├─ applications/ → 18 files → flake.homeModules.applications
            ├─ services/ → 6 files → flake.homeModules.services
            └─ dev/  → 3 files → flake.homeModules.dev
```

### How Hosts Work

Each host has:
1. **`modules/nixos/<host>.nix`** — Top-level flake-parts module that exports two things:
   - `flake.nixosModules.<host>` — A NixOS module containing all host config (imports `self.nixosModules.*` for features, sets hostname, users, home-manager)
   - `flake.nixosConfigurations.<host>` — A NixOS system build using that module
2. **`modules/nixos/<host>/`** — Directory with `_`-prefixed split modules (host-specific config, hardware)

The host module passes `specialArgs = { inherit inputs self; }` to `nixosSystem` and `extraSpecialArgs = { inherit inputs self; }` to `home-manager`, making `self` and `inputs` available in all sub-modules.

### How Users Work

The single user `plasmaa0` is defined in:
- **`modules/home/plasmaa0.nix`** — Exports `flake.homeModules.plasmaa0`, the user's HM entry point
- It imports 9 group modules: `common`, `secrets`, `shell-templates`, `stylix`, `cli`, `desktop`, `applications`, `services`, `dev`
- Host modules (`nb.nix`, `zep.nix`) create the user via `home-manager.users.plasmaa0.imports = [ self.homeModules.stylix self.homeModules.plasmaa0 ]`

### `self` / `inputs` Availability

| Context | `self` available? | `inputs` available? | Mechanism |
|---------|------------------|-------------------|-----------|
| NixOS modules (in `nixosModules.*`) | Yes (via `specialArgs`) | Yes (via `specialArgs`) | Host sets `specialArgs = { inherit inputs self; }` |
| HM modules (in `homeModules.*`) | Yes (via `extraSpecialArgs`) | Yes (via `extraSpecialArgs`) | Host sets `home-manager.extraSpecialArgs = { inherit inputs self; }` |
| Top-level flake-parts modules | Yes (`self` is a module arg) | Yes (`inputs` is a module arg) | Built-in from flake-parts |

---

## Build Instructions

The `justfile` at the repo root orchestrates all build tasks:

| Command | Action |
|---------|--------|
| `just rebuild-boot` | all-checks → copy to /etc/nixos → `nixos-rebuild boot` |
| `just rebuild-switch` | all-checks → copy → `nixos-rebuild switch` |
| `just rebuild-test` | all-checks → copy → `nixos-rebuild test` |
| `just rebuild-switch-specific <host>` | Build only one host |
| `just rebuild-update` | Update `flake.lock` → rebuild-boot |
| `just check_dead` | deadnix check (excludes old shell_templates) |
| `just format` | alejandra format + just --fmt |
| `just lint` | statix check |
| `just all-checks` | format → check_dead → lint |

**Build flow in detail:**

```bash
# 1. Production: uses old flake.nix
just rebuild-boot
#   → sudo rm -rf /etc/nixos/*
#   → sudo cp -r configuration/* /etc/nixos
#   → sudo nixos-rebuild boot --flake /etc/nixos --show-trace

# 2. Test-build the new refactored config:
nix build '.#nixosConfigurations.zep.config.system.build.toplevel' \
  --flake /home/plasmaa0/home-manager/configuration/flake-new.nix

# 3. Or check evaluation without building:
nix flake check --flake /home/plasmaa0/home-manager/configuration/flake-new.nix
```

**Files involved in production build (old config):**
- `configuration/flake.nix` — entry point, calls `mkSystem`
- `configuration/mkSystem.nix` — builder: `nixosSystem` with modules from `hosts/<host>` + `homes/<user>`
- `configuration/hosts/` — NixOS host configs
- `configuration/homes/` — HM user configs

**Files involved in new refactored build:**
- `configuration/flake-new.nix` — entry point, calls `importTree(./modules)` + `mkFlake`
- `configuration/modules/` — all flake-parts modules (auto-discovered)
- `configuration/modules/parts.nix` — systems + home-manager setup

---

## Dendritic Pattern Reference

### The `importTree` Function

In `flake-new.nix`:

```nix
isNixModule = file:
  file.hasExt "nix"           # must be .nix
  && file.name != "flake.nix" # skip the entry point
  && !lib.hasPrefix "_" file.name;  # skip _-prefixed files

importTree = path: toList (fileFilter isNixModule path);
```

**What gets auto-imported:** Every `.nix` file in `modules/` whose filename does NOT start with `_`.  
**What is excluded:** `_*-prefixed` files (split sub-modules, hardware configs, password files, etc.)

### Module Export Patterns

Every non-entry `.nix` file is a flake-parts module. It must return an attribute set. The most common exports:

```nix
# Pattern 1: Export a single NixOS module
{ ... }: {
  flake.nixosModules.someFeature = { pkgs, lib, config, ... }: {
    # NixOS config options
    services.something.enable = true;
    environment.systemPackages = [ pkgs.something ];
  };
}

# Pattern 2: Export a single HM module
{ ... }: {
  flake.homeModules.someFeature = { pkgs, config, ... }: {
    # home-manager config
    programs.something.enable = true;
    home.packages = [ pkgs.something ];
  };
}

# Pattern 3: Share a key with other files (dendritic merge)
{ ... }: {
  flake.homeModules.cli = { pkgs, ... }: {
    # This merges with all other files exporting flake.homeModules.cli
    programs.helix.enable = true;
  };
}

# Pattern 4: Export a host definition + system build
{ inputs, self, ... }: {
  flake.nixosModules.myHost = { lib, pkgs, ... }: {
    imports = with self.nixosModules; [ base audio ... ];
    networking.hostName = "myhost";
    home-manager.users.plasmaa0.imports = [ self.homeModules.plasmaa0 ];
  };
  flake.nixosConfigurations.myHost = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ self.nixosModules.myHost ];
    specialArgs = { inherit inputs self; };
  };
}

# Pattern 5: Export both NixOS and HM modules in one file
{ ... }: {
  flake.nixosModules.stylix = { ... }: { /* NixOS config */ };
  flake.homeModules.stylix = { ... }: { /* HM config */ };
}
```

### Grouped HM Keys (Dendritic Merge)

These directories each export a **shared** key — multiple files contribute to one merged module:

| Directory path | Exported key | Files | What it contains |
|---|---|---|---|
| `modules/home/cli/` | `flake.homeModules.cli` | 13 | helix, markdown-oxide, fish, starship, alacritty, kitty, wezterm, btop, direnv, git, fastfetch, yazi, cli-packages |
| `modules/home/desktop/common/` | `flake.homeModules.desktop` | 8 | i3, betterlockscreen, polybar, picom, dunst, rofi, conky, eww |
| `modules/home/applications/` | `flake.homeModules.applications` | 18 | mime, firefox alternatives, telegram, music players, editors, media, games |
| `modules/home/services/` | `flake.homeModules.services` | 6 | flameshot, copyq, powertop, udiskie, kde-connect, poweralertd |
| `modules/home/dev/` | `flake.homeModules.dev` | 3 | typst, latex, python |

**Standalone keys** (single file → single module):

| File | Key | Purpose |
|---|---|---|
| `modules/home/common.nix` | `flake.homeModules.common` | Base HM: persistence, activation, xsession, stateVersion |
| `modules/home/secrets.nix` | `flake.homeModules.secrets` | Git config, GitHub access tokens |
| `modules/home/shell-templates/default.nix` | `flake.homeModules.shell-templates` | `mkenv` script + templates |
| `modules/home/plasmaa0.nix` | `flake.homeModules.plasmaa0` | User entry: packages, persistence, imports all groups |
| `modules/nixos/stylix.nix` | `flake.homeModules.stylix` | User-level stylix targets, xresources |

**NixOS modules** do NOT use sharing — each file exports a unique `flake.nixosModules.*` key.

### The `_` Prefix Convention

Files starting with `_` are **excluded from auto-import** by `importTree`. They must be manually imported by their parent module.

**Use cases for `_` prefix:**
- Split sub-modules of a directory-based module (helix languages, helix settings, fish sub-modules)
- Hardware config files (hardware-configuration.nix, NVIDIA configs)
- Secret/password files (password hashes, secrets nix)
- Template files (shell template files)
- Helper files that aren't full modules (generate-theme-preview, gowall-recolor-wallpaper)
- Host-specific config splits

```nix
# Example: helix/default.nix manually imports _-prefixed files
{ ... }: {
  flake.homeModules.cli = { pkgs, config, ... }: {
    imports = [
      ./_theme.nix
      ./_settings
      ./_languages
    ];
    programs.helix.package = inputs.helix.packages.${pkgs.system}.helix;
  };
}
```

### Host Module Structure

Each host module file follows this exact structure:

```nix
{
  inputs,      # flake inputs (from specialArgs)
  self,        # flake self (from specialArgs)
  ...
}: {
  # Export 1: The NixOS module for this host
  flake.nixosModules.<hostname> = { lib, pkgs, ... }: {
    imports = with self.nixosModules; [
      # List ALL feature modules this host needs
      feature1 feature2 feature3 ...
      # Host-specific config (split module, not auto-imported)
      ./<hostname>/_default.nix
    ];

    # Host-specific config
    networking.hostName = "<hostname>";
    hidpi = { enable = true; dpi = <value>; };

    # User setup
    users.users.plasmaa0 = {
      isNormalUser = true;
      extraGroups = [...];
      password = import ../home/secrets/_plasmaa0_password.nix;
    };

    # Home-manager wiring
    home-manager = {
      extraSpecialArgs = { inherit inputs self; };
      users.plasmaa0 = {
        imports = [
          self.homeModules.stylix
          self.homeModules.plasmaa0
        ];
      };
    };
  };

  # Export 2: The NixOS system build
  flake.nixosConfigurations.<hostname> = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ self.nixosModules.<hostname> ];
    specialArgs = { inherit inputs self; };
  };
}
```

### User Module Structure

```nix
{ ... }: {
  flake.homeModules.plasmaa0 = { pkgs, self, ... }: {
    imports = [
      # List grouped modules
      self.homeModules.common
      self.homeModules.secrets
      self.homeModules.shell-templates
      self.homeModules.stylix
      self.homeModules.cli
      self.homeModules.desktop
      self.homeModules.applications
      self.homeModules.services
      self.homeModules.dev
    ];

    # User-specific packages
    home.packages = with pkgs; [ ... ];

    # User-specific persistence
    home.persistence."/persist".directories = [ ... ];

    # User-specific mime config
    mime.enable = true;
    mime.list = [ ... ];
  };
}
```

---

## Complete File Inventory

### `modules/parts.nix` (1 file)

| File | Exported keys | What it does |
|---|---|---|
| `modules/parts.nix` | none (config only) | Sets `systems = ["x86_64-linux" "aarch64-linux"]`, imports `inputs.home-manager.flakeModules.home-manager`, configures `allowUnfree` pkgs |

### NixOS Common Modules: `modules/nixos/common/` (28 files)

Each exports a unique `flake.nixosModules.*`. All are simple pass-throughs — they contain the actual config inline (no `import` references to old files).

| File | Exported key | What it configures |
|---|---|---|
| `ananicy.nix` | `ananicy` | ananicy-cpp daemon for IO/CPU priority |
| `audio.nix` | `audio` | PipeWire, rtkit, realtime, low-latency audio |
| `automount.nix` | `automount` | Automatic mounting via udev + udisks |
| `autorandr.nix` | `autorandr` | Display profile auto-detection on connect |
| `autoUpgrade.nix` | `autoUpgrade` | Automatic system upgrade timer/script |
| `bluetooth.nix` | `bluetooth` | Bluetooth hardware + service |
| `bootloader.nix` | `bootloader` | systemd-boot + lanzaboote (Secure Boot) |
| `displayManager.nix` | `displayManager` | GDM, HiDPI for display manager, xserver, x11vnc |
| `firewall.nix` | `firewall` | nftables firewall config |
| `fonts.nix` | `fonts` | System fonts (nerd-fonts, noto, etc.) |
| `gamemode.nix` | `gamemode` | Feral Gamemode + MangoHud |
| `garbageCollect.nix` | `garbageCollect` | Automatic nix-collect-garbage timer |
| `gnupg.nix` | `gnupg` | GnuPG agent + SSH agent support |
| `HighDPI.nix` | `HighDPI` | Declares `hidpi.*` options (enable, dpi), enables HiDPI fonts |
| `impermanence.nix` | `impermanence` | Impermanence (root on tmpfs with persist) |
| `keymap.nix` | `keymap` | Console + X11 keymap (us) |
| `networking.nix` | `networking` | NetworkManager, VPN, mDNS |
| `nix-ld.nix` | `nix-ld` | nix-ld for running non-Nix binaries |
| `ollama.nix` | `ollama` | Ollama LLM server |
| `power_management.nix` | `power_management` | TLP, CPU governor, power profiles |
| `printing.nix` | `printing` | CUPS printing |
| `ssh.nix` | `ssh` | SSHD config |
| `steam.nix` | `steam` | Steam + 32-bit support |
| `systemd-lock-handler.nix` | `systemd-lock-handler` | systemd-logind lock handling |
| `time_and_i18n.nix` | `time_and_i18n` | Timezone, locale, i18n |
| `touchpad.nix` | `touchpad` | libinput touchpad config |
| `vial.nix` | `vial` | Vial keyboard configurator |
| `weylus.nix` | `weylus` | Weylus (use tablet/phone as graphics tablet) |
| `_gowall-recolor-wallpaper.nix` | (none, `_`-prefixed) | Helper: recolor wallpaper to match theme, used by stylix.nix |

### Host Modules: `modules/nixos/` (2 host files + 2 host dirs)

| File | Exported keys | Deps count | Notes |
|---|---|---|---|
| `nb.nix` | `nixosModules.nb`, `nixosConfigurations.nb` | 29 | Host "nb": dpi=192, bluetooth+steam+vial |
| `zep.nix` | `nixosModules.zep`, `nixosConfigurations.zep` | 30 | Host "zep": dpi=180, bluetooth+ollama+steam+vial+weylus, asusd |
| `nb/_default.nix` | (none, `_`-prefixed) | imports `_hardware` | Host-specific, sets stateVersion |
| `zep/_default.nix` | (none, `_`-prefixed) | imports `_hardware` | Host-specific, sets stateVersion |
| `nb/_hardware/` | (none, `_`-prefixed) | 3 files | hardware-config + NVIDIA config |
| `zep/_hardware/` | (none, `_`-prefixed) | 2 files | hardware-config + NVIDIA prime/offload |

### Stylix Module: `modules/nixos/stylix.nix` (1 file, exports both types)

| Exported key | What it configures |
|---|---|
| `flake.nixosModules.stylix` | Global NixOS stylix: wallpaper, fonts, cursor, icons, theme. Imports `inputs.stylix.nixosModules.stylix`. Sets `home-manager.sharedModules = [ self.homeModules.stylix ]` |
| `flake.homeModules.stylix` | User-level stylix: disables i3/helix target, enables qt target, sets Xft.dpi from extraSpecialArgs. Imports `_generate-theme-preview.nix` |

### Base HM Modules: `modules/home/` (4 standalone files + secrets dir + shell-templates dir)

| File | Exported key | What it configures |
|---|---|---|
| `common.nix` | `homeModules.common` | `programs.home-manager.enable`, `xsession.scriptPath`, persistence dirs (`~/.ssh`, `~/.gnupg`, Steam, etc.), activation script for `/data` symlink, `home.stateVersion = "24.05"` |
| `secrets.nix` | `homeModules.secrets` | `nix.settings.access-tokens` (GitHub PAT), `programs.git` user name/email |
| `plasmaa0.nix` | `homeModules.plasmaa0` | User entry: imports 9 group modules, user packages, user persistence dirs, mime config |
| `_generate-theme-preview.nix` | (none, `_`-prefixed) | Helper HM module for theme preview generation |
| `secrets/_secrets.nix` | (none, `_`-prefixed) | Wrapper importing password files |
| `secrets/_plasmaa0_password.nix` | (none, `_`-prefixed) | `plasmaa0` hashed password |
| `secrets/plasmaa0_hashed_password` | (none, plain file) | Password hash text file (non-nix asset) |
| `secrets/root_hashed_password` | (none, plain file) | Root password hash text file (non-nix asset) |
| `shell-templates/default.nix` | `homeModules.shell-templates` | `mkenv` script: creates flake-based dev environments from templates |
| `shell-templates/_template_cpp.nix` | (none, `_`-prefixed) | C++ dev shell template |
| `shell-templates/_template_empty.nix` | (none, `_`-prefixed) | Empty dev shell template |

### CLI Group: `modules/home/cli/` (13 files → `flake.homeModules.cli`)

| File/Directory | What it configures |
|---|---|
| `default.nix` | CLI packages: curl, wget, ripgrep, fd, bat, jq, unzip, etc. |
| `editor/helix/default.nix` | Helix editor with `inputs.helix` package, imports `_theme.nix`, `_settings/*`, `_languages/*` |
| `editor/helix/_theme.nix` | Helix theme (stylix-based colors) |
| `editor/helix/_settings/*` (4 files) | Helix settings: default, editor, ignore, keys |
| `editor/helix/_languages/*` (8 files + 1 sub-dir) | Helix language configs: cpp, python, nix, latex, typst, yuck, template, default + YuckLS lsp |
| `editor/helix/_languages/YuckLS-lsp/deps.json` | LSP dependency metadata |
| `editor/markdown-oxide/default.nix` | Markdown-oxide (LSP for markdown) |
| `shell/fish/default.nix` | Fish shell: imports `_abbrs`, `_aliases`, `_binds`, `_functions`, `_plugins` |
| `shell/fish/_*` (5 files) | Fish sub-modules: abbreviations, aliases, key bindings, functions, plugins |
| `shell/starship/default.nix` | Starship prompt (stylix-colored) |
| `terminal/alacritty/default.nix` | Alacritty terminal (stylix colors) |
| `terminal/kitty/default.nix` | Kitty terminal |
| `terminal/wezterm/default.nix` | Wezterm terminal + copies `wezterm.lua` |
| `terminal/wezterm/wezterm.lua` | Wezterm Lua config file (non-nix asset) |
| `utils/btop.nix` | Btop system monitor |
| `utils/direnv.nix` | Direnv environment loader |
| `utils/git.nix` | Git config (delta diff, aliases, LFS) |
| `utils/fastfetch/default.nix` | Fastfetch system info + `NixOS.png` logo |
| `utils/fastfetch/NixOS.png` | Logo image for fastfetch |
| `utils/yazi/default.nix` | Yazi file manager + plugins (compress, max-preview, restore, smart-enter, smart-filter) |

### Desktop Group: `modules/home/desktop/common/` (8 files → `flake.homeModules.desktop`)

| File/Directory | What it configures |
|---|---|
| `i3.nix` | i3 window manager (inlined content, no aggregator imports): keybindings, colors (stylix), gaps, window rules, modes (resize, launch), startup programs, multi-monitor, asusctl aura |
| `betterlockscreen.nix` | Betterlockscreen (i3lock wrapper) |
| `polybar/default.nix` | Polybar config + `config.ini`, `playerctl.sh`, `scroll_song_info.sh`, `redshift.sh` |
| `polybar/polybar/*` | Polybar assets: config (183 lines), scripts, redshift integration |
| `picom/default.nix` | Picom compositor (stylix colors) |
| `dunst.nix` | Dunst notification daemon (stylix colors) |
| `rofi/default.nix` | Rofi launcher + themes: launchers (type-2), powermenu (type-2), todo |
| `rofi/rofi/*` | Rofi assets: config.rasi, launcher scripts/styles, powermenu scripts/styles, todo scripts/styles |
| `conky/default.nix` | Conky system monitor + `conky.conf` |
| `eww/default.nix` | Eww widgets + SCSS, Yuck, scripts, images |
| `eww/eww/*` | Eww assets: colors.scss, eww.scss, eww.yuck, scripts (Network, Volume, WorkSpaces, playerctl), images (NixOS.png, music-note, volume, wifi, etc.) |

### Applications Group: `modules/home/applications/` (18 files → `flake.homeModules.applications`)

| File/Directory | What it configures |
|---|---|
| `mime.nix` | Declares `mime.enable` + `mime.list` option, sets `xdg.mime.defaultApplications` and `xdg.desktopEntries` for custom handlers |
| `browser/qutebrowser.nix` | Qutebrowser config |
| `browser/helium.nix` | Helium browser (from `inputs.helium`) |
| `social/telegram.nix` | Telegram Desktop |
| `music/cassette.nix` | Cassette music player |
| `music/yandex-music.nix` | Yandex Music (Cider) |
| `music/mpd.nix` | MPD music daemon |
| `music/rmpc/default.nix` | RMPC (MPD client) + album art, lyrics scripts |
| `music/rmpc/default_album_art.png` | Default album art image |
| `music/rmpc/fetch_album_lyrics.sh` | Album lyrics fetcher script |
| `music/rmpc/fetch_all_lyrics.sh` | Batch lyrics fetcher script |
| `editor/vscode.nix` | VS Code + extensions |
| `editor/texstudio.nix` | TeXstudio LaTeX editor |
| `editor/xournalpp.nix` | Xournal++ notetaking |
| `media/zathura.nix` | Zathura PDF viewer (stylix colors) |
| `media/vlc.nix` | VLC media player |
| `media/easyeffects.nix` | EasyEffects audio effects |
| `media/obs.nix` | OBS Studio |
| `utils/gparted.nix` | GParted partition editor |
| `utils/mangohud.nix` | MangoHud performance overlay |
| `games/minecraft.nix` | Minecraft + Prism Launcher |

### Services Group: `modules/home/services/` (6 files → `flake.homeModules.services`)

| File | What it configures |
|---|---|
| `flameshot.nix` | Flameshot screenshot tool |
| `copyq.nix` | CopyQ clipboard manager |
| `powertop.nix` | Powertop power tuning |
| `udiskie.nix` | Udiskie automount |
| `kde-connect.nix` | KDE Connect phone integration |
| `poweralertd.nix` | Power alert daemon |

### Dev Group: `modules/home/dev/` (3 files → `flake.homeModules.dev`)

| File | What it configures |
|---|---|
| `typst.nix` | Typst typesetting + tinymist LSP |
| `latex.nix` | TeX Live LaTeX distribution |
| `python.nix` | Python + uv package manager |

### Non-Nix Asset Inventory (60+ files)

| Category | Location | Files |
|---|---|---|
| Eww widgets | `modules/home/desktop/common/eww/eww/` | colors.scss, eww.scss, eww.yuck, 8 images (png/svg), 9 scripts |
| Polybar | `modules/home/desktop/common/polybar/polybar/` | config.ini (183 lines), playerctl.sh, scroll_song_info.sh, redshift (env.sh, redshift.sh, README) |
| Rofi | `modules/home/desktop/common/rofi/rofi/` | config.rasi, launcher scripts/styles, powermenu scripts/styles, todo scripts/styles |
| Conky | `modules/home/desktop/common/conky/` | conky.conf |
| Wezterm | `modules/home/cli/terminal/wezterm/` | wezterm.lua |
| Yazi | `modules/home/cli/utils/yazi/` | 5 plugin dirs (compress, max-preview, restore, smart-enter, smart-filter) with .git, init.lua, LICENSE, README |
| Fastfetch | `modules/home/cli/utils/fastfetch/` | NixOS.png logo |
| RMPC | `modules/home/applications/music/rmpc/` | default_album_art.png, 2 bash scripts |
| Passwords | `modules/home/secrets/` | plasmaa0_hashed_password, root_hashed_password |

---

## Conventions

### Naming

- **Directory names**: NEVER start with `_`. Directories organize files by category (cli, desktop, applications, etc.)
- **File names**: Start with `_` ONLY for files that are split sub-modules manually imported by a parent. Examples: `_languages/_cpp.nix`, `_hardware/_default.nix`, `_settings/_editor.nix`
- **Aggregator files**: DO NOT create aggregator files that just re-export other modules. Each module stands alone.
- **Host/user module files**: Named after the host/user (e.g., `nb.nix`, `zep.nix`, `plasmaa0.nix`)

### Module Structure

- Every non-`_` `.nix` file in `modules/` is a flake-parts module (auto-imported)
- Every module exports one or more `flake.*` keys
- NixOS modules export `flake.nixosModules.*`
- HM modules export `flake.homeModules.*`
- A single file CAN export both types (see `stylix.nix`)
- `parts.nix` is the only module that doesn't export `flake.*` — it sets `systems` and imports the home-manager flake module

### Imports

- **NixOS host modules** list ALL `self.nixosModules.*` dependencies explicitly — no implicit imports
- **HM user module** (`plasmaa0.nix`) lists ALL group `self.homeModules.*` imports explicitly
- **Never use `import` to reference old `homes/` or `hosts/` files** — all content is inlined
- Use `with self.nixosModules; [...]` in host modules to reduce repetition

### Secret Files

- Secrets use the `_` prefix to avoid auto-import
- Secrets are stored as `import`-ed nix files in `modules/home/secrets/`
- Hashed password files are plain text (no nix)
- `nb.nix` and `zep.nix` reference secrets via `import ../home/secrets/_plasmaa0_password.nix` (relative from `modules/nixos/` to `modules/home/secrets/`)

### `self` and `inputs`

- `self` and `inputs` are available in NixOS modules via `specialArgs` (set in host module)
- `self` and `inputs` are available in HM modules via `extraSpecialArgs` (set in host module)
- DO NOT add `self` or `inputs` to individual module function arguments unless they specifically need them
- Use `self.nixosModules.*` and `self.homeModules.*` to reference other modules

---

## How To: Add / Modify / Remove

### Add a new NixOS feature module

1. Create `modules/nixos/common/<feature>.nix`:
   ```nix
   { lib, pkgs, config, ... }: {
     flake.nixosModules.<feature> = { ... }: {
       # Your NixOS config
       services.<feature>.enable = true;
     };
   }
   ```
2. No import needed — `importTree` discovers it automatically
3. Add `self.nixosModules.<feature>` to the import list of any host that should use it

### Add a new HM CLI module

1. Create a file or directory under `modules/home/cli/`
2. Export `flake.homeModules.cli`:
   ```nix
   { pkgs, ... }: {
     flake.homeModules.cli = { ... }: {
       programs.<thing>.enable = true;
     };
   }
   ```
3. No import needed — it's auto-merged into the `cli` group

### Add a new HM application

1. Place the file under `modules/home/applications/` (or a subdirectory)
2. Export `flake.homeModules.applications`
3. No import needed — auto-merged

### Add a new host

1. Create `modules/nixos/<hostname>.nix` following the host module pattern (exports `nixosModules.<hostname>` + `nixosConfigurations.<hostname>`)
2. Create `modules/nixos/<hostname>/` with `_default.nix` and `_hardware/` subdirectory
3. Copy hardware-configuration.nix from the machine into `_hardware/_hardware-configuration.nix`
4. Copy any machine-specific config into `_hardware/_default.nix`
5. Add `self.nixosModules.<hostname>` imports for all desired features
6. Set `networking.hostName`, `hidpi`, user config, and home-manager wiring

### Add a new user

Currently there's only `plasmaa0`. To add another user:
1. Create `modules/home/<username>.nix` exporting `flake.homeModules.<username>`
2. Add user section to each host module's `users.users.*` and `home-manager.users.*`
3. Create password file under `modules/home/secrets/`
4. Add user-specific persistence and packages in their module

### Remove a module

1. Delete the `.nix` file
2. Remove it from any host import lists (for NixOS modules) or user import lists (for HM modules)
3. That's it — `importTree` won't discover deleted files

### Rename a module export key

1. Change `flake.homeModules.<old>` to `flake.homeModules.<new>` (or `flake.nixosModules.*`)
2. Update all references: `self.homeModules.<old>` → `self.homeModules.<new>`
3. This includes host module `home-manager.users.*.imports` and user module imports

### Split a large module into sub-files

1. Keep the main file as the entry point (exporting `flake.*`)
2. Create sub-files with `_` prefix in a subdirectory
3. Import them in the main file's `imports` list
4. Example: helix `default.nix` → `_theme.nix`, `_settings/*`, `_languages/*`
5. Sub-files don't need to export anything — they can be regular modules

---

## What Has Been Done

### Phase 1: Foundation ✓
- `flake-new.nix` with custom `importTree` using `lib.fileset.fileFilter` (excludes `_*` and `flake.nix`)
- `modules/parts.nix` — systems = ["x86_64-linux" "aarch64-linux"], home-manager flake module, allowUnfree

### Phase 2: NixOS Modules ✓
- 28 modules from `hosts/common/*` + `hosts/common/modules/*` — each standalone flake-parts module with unique `flake.nixosModules.*` keys
- `modules/nixos/stylix.nix` — merged global-stylix + user-stylix, exports both `flake.nixosModules.stylix` (NixOS) and `flake.homeModules.stylix` (HM)
- `modules/nixos/nb.nix` — host "nb": 29 explicit `self.nixosModules.*` imports, dpi=192, bluetooth+steam+vial
- `modules/nixos/zep.nix` — host "zep": 30 explicit `self.nixosModules.*` imports, dpi=180, bluetooth+ollama+steam+vial+weylus
- Host-specific splits under `nb/` and `zep/` with `_`-prefixed hardware configs
- All hardware assets copied (hardware-configuration.nix × 2, I_HATE_NVIDIA.nix)

### Phase 3: Base HM Modules ✓
- `common.nix` — `programs.home-manager.enable`, xsession, persistence dirs, activation, stateVersion
- `secrets.nix` — git config + GitHub PAT
- `secrets/` — password hashes with `_`-prefixed nix wrappers
- `shell-templates/` — `mkenv` script + `_template_*.nix` for dev environments
- `plasmaa0.nix` — user entry with 9 group imports, user packages, user persistence, mime config

### Phase 4: CLI Group ✓
13 files → `flake.homeModules.cli`: helix (+ languages, settings, theme), markdown-oxide, fish (+ abbrs, aliases, binds, functions, plugins), starship, alacritty, kitty, wezterm, btop, direnv, git, fastfetch, yazi (+ 5 plugins), CLI packages

### Phase 5: Desktop Group ✓
8 files → `flake.homeModules.desktop`: i3 (inlined, no aggregator), betterlockscreen, polybar (+ config.ini, scripts, redshift), picom, dunst, rofi (+ launchers, powermenu, todo), conky (+ conky.conf), eww (+ SCSS, Yuck, scripts, images)

### Phase 6: Applications Group ✓
18 files → `flake.homeModules.applications`: mime, qutebrowser, helium, telegram, cassette, yandex-music, mpd, rmpc (+ album art, lyrics scripts), vscode, texstudio, xournalpp, zathura, vlc, easyeffects, obs, gparted, mangohud, minecraft

### Phase 7: Services + Dev Groups ✓
6 files → `flake.homeModules.services`: flameshot, copyq, powertop, udiskie, kde-connect, poweralertd
3 files → `flake.homeModules.dev`: typst, latex, python

### Phase 8: Non-Nix Assets ✓
60+ files: eww (9 scripts, 8 images, 3 CSS/Yuck), polybar (config.ini, 3 scripts, redshift), rofi (config.rasi, 6 scripts/styles), conky.conf, wezterm.lua, yazi (5 plugin dirs), rmpc (1 image, 2 scripts), fastfetch NixOS.png

---

## Transition Procedure

### Test-Build the New Config

```bash
# Check evaluation (no build):
nix flake check --flake /home/plasmaa0/home-manager/configuration/flake-new.nix

# Full build test:
nix build '.#nixosConfigurations.zep.config.system.build.toplevel' \
  --flake /home/plasmaa0/home-manager/configuration/flake-new.nix

# Or build for specific host:
nix build '.#nixosConfigurations.nb.config.system.build.toplevel' \
  --flake /home/plasmaa0/home-manager/configuration/flake-new.nix
```

### Switch Over

```bash
# 1. Activate the new flake as the entry point
cp configuration/flake-new.nix configuration/flake.nix

# 2. Remove old structure (no longer referenced)
rm -rf configuration/hosts
rm -rf configuration/homes
rm -f configuration/mkSystem.nix

# 3. Remove unused flake inputs from old flake.nix
#    (import-tree was only used by old flake.nix)
#    Edit configuration/flake.nix and remove:
#    import-tree.url = "github:vic/import-tree";

# 4. Regenerate lock file (drops unused inputs)
nix flake lock --flake /home/plasmaa0/home-manager/configuration

# 5. Clean up old deadnix exclude (if shell_templates dir is gone)
#    Edit justfile: update deadnix --exclude path

# 6. Build and reboot
just rebuild-boot
```

### Post-Transition Cleanup

- Delete `configuration/flake-new.nix` (replaced by `flake.nix`)
- Update `justfile` `create-host` recipe to create host dirs in `modules/nixos/` instead of `hosts/`
- Verify `listHosts` recipe works with new structure
- Remove `import-tree` from `flake.lock` input tracking

---

## Troubleshooting & Pitfalls

### Common Issues

**"attribute 'xxx' missing" during build**
→ The host module imports `self.nixosModules.xxx` but that module doesn't exist. Check if the file exists or if the key name is correct.

**"infinite recursion" error**
→ Likely a circular `self.homeModules.*` or `self.nixosModules.*` reference. Most common cause: two modules reference each other via `self`. The `stylix.nix` references `self.homeModules.stylix` in `home-manager.sharedModules` — this works because it's a deferred module reference, not an immediate evaluation.

**"cannot find file /home/.../home/secrets/..." during build**
→ The host module `nb.nix` and `zep.nix` reference `../home/secrets/_plasmaa0_password.nix`. This relative path resolves from `modules/nixos/` → `modules/home/secrets/`. If the file is missing or moved, this will fail.

**"option `mime' does not exist"**
→ The `mime.enable` option is declared in `applications/mime.nix`. If that module isn't being imported (because it's in the `applications` group but not properly merged), this error occurs. Check that `mime.nix` is in the `applications/` directory and exports `flake.homeModules.applications`.

**"option `hidpi' does not exist"**
→ The `hidpi.*` options are declared by `modules/nixos/common/HighDPI.nix`. If a host doesn't import `self.nixosModules.HighDPI` (note: capital H), options won't be available.

**"flake-parts: No systems defined"**
→ `modules/parts.nix` must set `systems = ["x86_64-linux" "aarch64-linux"]`. If this is missing, flake-parts won't know what systems to evaluate for.

**"importTree returned empty list"**
→ If `./modules` path is wrong, or if all files somehow have `_` prefix, `importTree` returns nothing. Check the relative path in `flake-new.nix` — it should be `./modules` relative to `configuration/`.

### Debugging Tips

```bash
# Check which files importTree would discover:
nix eval --flake /home/plasmaa0/home-manager/configuration/flake-new.nix \
  '.#imports' 2>/dev/null || echo "eval failed"

# Trace evaluation to find errors:
nix build '.#nixosConfigurations.zep.config.system.build.toplevel' \
  --flake /home/plasmaa0/home-manager/configuration/flake-new.nix \
  --show-trace 2>&1 | head -50

# Check if the `_` prefix rule is correct:
ls configuration/modules/**/_*.nix  # should show excluded files
ls configuration/modules/**/[^_]*.nix  # should show auto-imported files

# Verify all self.nixosModules.* references resolve:
rg 'self\.nixosModules\.' configuration/modules/nixos/ | sort -u
rg 'self\.homeModules\.' configuration/modules/home/ | sort -u
```

### Important Notes

- **Every NixOS module must be explicitly imported by a host.** Auto-discovery only applies to flake-parts modules (the `.nix` files themselves), NOT to NixOS modules being used in evaluations. Hosts must explicitly list `self.nixosModules.*` in their `imports`.
- **`self.homeModules.*` groups are auto-merged by flake-parts.** Multiple files exporting `flake.homeModules.cli` all contribute to one merged HM module. This is by design.
- **The `_` prefix is the ONLY exclusion mechanism.** If you want a `.nix` file in `modules/` to NOT be auto-imported, prefix its name with `_`.
- **`parts.nix` must be at the right location.** `importTree(./modules)` discovers it automatically. It sets `systems` without which flake-parts cannot evaluate.
- **`pkgs` with `allowUnfree` is configured in `parts.nix` via `perSystem._module.args.pkgs`.** Individual modules should NOT set `nixpkgs.config.allowUnfree` — it's handled centrally.
