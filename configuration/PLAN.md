# Refactoring Plan: Dendritic Nix Configuration

## Build Instructions

The `justfile` at the repo root orchestrates all build tasks:

| Command | Action |
|---------|--------|
| `just rebuild-boot` | Run checks, copy `configuration/` → `/etc/nixos`, build boot |
| `just rebuild-switch` | Same, but switch to new generation |
| `just rebuild-test` | Same, but test (no boot entry) |
| `just rebuild-switch-specific <host>` | Build only one host |
| `just rebuild-update` | Update flake.lock → rebuild-boot |
| `just check_dead` | deadnix check |
| `just format` | alejandra format + just --fmt |
| `just lint` | statix check |
| `just all-checks` | format → check_dead → lint |

**Build flow:**
1. `just make-configuration`: `sudo rm -rf /etc/nixos/* && sudo cp -r configuration/* /etc/nixos`
2. `sudo nixos-rebuild boot --flake /etc/nixos --show-trace`
3. The old entry point reads from `configuration/flake.nix` which uses `mkSystem.nix`

**Current production entry point:** `configuration/flake.nix` (uses `mkSystem.nix` with `hosts/` + `homes/`)
**New refactored entry point:** `configuration/flake-new.nix` (uses `lib.fileset.fileFilter` auto-import of `./modules`)

**To switch to new config:** Replace `flake.nix` with `flake-new.nix` and ensure the old `hosts/` + `homes/` dirs are no longer referenced.

---

## Dendritic Pattern

Reference implementation: `/home/plasmaa0/infa/repos/nixconf`

### Core Idea

Every `.nix` file (except entry points) is a module of the **top-level flake-parts configuration**. Files export values under `flake.*` namespaced keys. Flake-parts merges all `flake` attributes from all modules, so multiple files can contribute to the **same key**.

### Automatic Import

```nix
# flake-new.nix
isNixModule = file:
  file.hasExt "nix"
  && file.name != "flake.nix"
  && !lib.hasPrefix "_" file.name;

importTree = path: toList (fileFilter isNixModule path);

mkFlake {imports = importTree ./modules;};
```

- Every `.nix` file in `modules/` is auto-imported
- Files with `_` prefix are excluded (split sub-modules, hardware configs, etc.)
- `parts.nix` is the only special file (declares systems + imports home-manager flake module)

### Module Export Pattern

```nix
# modules/nixos/common/audio.nix — single key export
{ ... }: {
  flake.nixosModules.audio = { ... }: {
    services.pipewire.enable = true;
  };
}

# modules/home/applications/browser/qutebrowser.nix — shared key with other apps
{ ... }: {
  flake.homeModules.applications = { pkgs, ... }: {
    programs.qutebrowser.enable = true;
  };
}
```

### Key Sharing (Dendritic Merge)

Multiple files can export the **same** `flake.*` key — flake-parts merges them:

| Directory | All files export | Creates one module |
|-----------|-----------------|-------------------|
| `modules/home/cli/` | `flake.homeModules.cli` | Combined CLI module |
| `modules/home/desktop/` | `flake.homeModules.desktop` | Combined desktop module |
| `modules/home/applications/` | `flake.homeModules.applications` | Combined apps module |
| `modules/home/services/` | `flake.homeModules.services` | Combined services module |
| `modules/home/dev/` | `flake.homeModules.dev` | Combined dev module |

Standalone keys (unique modules):
- `flake.homeModules.common` — base HM config
- `flake.homeModules.secrets` — git config / access tokens
- `flake.homeModules.shell-templates` — mkenv script
- `flake.homeModules.stylix` — user-level stylix targets
- `flake.homeModules.plasmaa0` — user entry point

NixOS modules each have unique keys (no sharing).

### Host Module Pattern

A host module is a NixOS module that explicitly imports `self.nixosModules.*` and defines home-manager setup:

```nix
# modules/nixos/nb.nix
{ inputs, self, ... }: {
  flake.nixosModules.nb = { lib, pkgs, ... }: {
    imports = with self.nixosModules; [
      impermanence ananicy audio automount autorandr
      autoUpgrade bootloader displayManager firewall
      fonts gamemode garbageCollect gnupg keymap
      networking nix-ld power_management printing ssh
      systemd-lock-handler time_and_i18n touchpad
      HighDPI bluetooth steam vial stylix
      ./nb/_default.nix
    ];
    networking.hostName = "nb";
    home-manager = {
      extraSpecialArgs = { inherit inputs self; };
      users.plasmaa0 = {
        imports = [ self.homeModules.stylix self.homeModules.plasmaa0 ];
      };
    };
  };
  flake.nixosConfigurations.nb = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ self.nixosModules.nb ];
    specialArgs = { inherit inputs self; };
  };
}
```

### User Module Pattern

```nix
# modules/home/plasmaa0.nix
{ ... }: {
  flake.homeModules.plasmaa0 = { pkgs, self, ... }: {
    imports = [
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
    home.packages = with pkgs; [ networkmanagerapplet upower ... ];
    home.persistence."/persist".directories = [ "infa" "uni" ... ];
  };
}
```

### `self` / `inputs` Availability

- `self` and `inputs` are passed via `specialArgs` to NixOS evaluations
- `self` and `inputs` are passed via `extraSpecialArgs` to HM evaluations
- Host modules (`nb.nix`, `zep.nix`) set these up
- Modules inside nixos/ or home/ can then use `self.nixosModules.*`, `self.homeModules.*`, `inputs.*`

---

## Old Structure (Production)

```
configuration/
├── flake.nix                    # Entry point, uses mkSystem.nix
├── mkSystem.nix                 # System builder: imports hosts/<host> + homes/<user>
├── hosts/
│   ├── common/                  # 27 shared NixOS modules + 6 optional
│   │   ├── audio.nix, bootloader.nix, fonts.nix, ...
│   │   └── modules/             # bluetooth, HighDPI, steam, ollama, vial, weylus
│   ├── nb/                      # Host-specific NixOS config
│   │   ├── default.nix
│   │   └── hardware/            # default, hardware-configuration, I_HATE_NVIDIA
│   └── zep/                     # Host-specific NixOS config
│       ├── default.nix
│       └── hardware/            # default, hardware-configuration
├── homes/
│   ├── common/                  # ~83 Nix files (aggregator pattern)
│   │   ├── default.nix          # Top aggregator → cli, desktop/i3, applications, dev
│   │   ├── cli/                 # Dir aggregator → helix, fish, starship, terminal, utils
│   │   ├── desktop/             # Dir aggregator → i3, common (polybar, rofi, picom, ...)
│   │   ├── applications/        # Dir aggregator → browser, music, editor, media, games
│   │   ├── services/            # 6 service modules
│   │   ├── dev/                 # latex, python, typst
│   │   ├── secrets/             # git tokens, password hashes
│   │   ├── shell_templates/     # mkenv script + template files
│   │   ├── user-stylix.nix
│   │   └── generate-theme-preview.nix
│   └── plasmaa0/
│       └── default.nix          # User entry importing aggregators
├── themes/                      # Theme color schemes
└── wallpapers/                  # Wallpaper images
```

**Old totals:** ~83 home `.nix` + 38 host `.nix` = ~121 Nix files + assets

---

## New Structure (Refactored)

```
configuration/
├── flake-new.nix                # Entry point, uses importTree(./modules)
├── modules/
│   ├── parts.nix                # Systems + home-manager flake module + pkgs config
│   │
│   ├── nixos/                   # 31 NixOS modules (+ 8 _-prefixed splits)
│   │   ├── nb.nix, zep.nix      # Host definitions with explicit dep lists
│   │   ├── stylix.nix           # Merged NixOS + HM stylix (exports both keys)
│   │   ├── nb/                  # _default.nix + _hardware/* (NVIDIA)
│   │   ├── zep/                 # _default.nix + _hardware/*
│   │   └── common/              # 28 modules (flat, no aggregators)
│   │
│   └── home/                    # 52 modules (+ 24 _-prefixed splits)
│       ├── plasmaa0.nix         # User entry, 9 group imports
│       ├── common.nix           # Base HM config
│       ├── secrets.nix          # Git config + tokens
│       ├── secrets/             # Password hashes
│       ├── shell-templates/     # mkenv + _template_*.nix
│       ├── cli/                 # 13 files → flake.homeModules.cli
│       ├── desktop/             # 8 files → flake.homeModules.desktop
│       ├── applications/        # 18 files → flake.homeModules.applications
│       ├── services/            # 6 files → flake.homeModules.services
│       └── dev/                 # 3 files → flake.homeModules.dev
├── themes/                      # Unchanged
└── wallpapers/                  # Unchanged
```

**New totals:** 52 home `.nix` + 24 `_`-prefixed + 31 nixos `.nix` + 8 `_`-prefixed + 1 parts.nix = **116 Nix files** + 60 non-nix asset files

---

## What Has Been Done

### Phase 1: Foundation ✓
- Created `flake-new.nix` with custom `importTree` using `lib.fileset.fileFilter`
- Created `modules/parts.nix` declaring 2 systems + home-manager flake module + pkgs config

### Phase 2: NixOS Modules ✓
- 28 modules from `hosts/common/*` + `hosts/common/modules/*` — each standalone flake-parts module
- `modules/nixos/stylix.nix` — merged global-stylix + user-stylix, exports both `flake.nixosModules.stylix` and `flake.homeModules.stylix`
- Host modules `nb.nix` (29 imports) + `zep.nix` (30 imports) with explicit `self.nixosModules.*` deps
- Split host configs into `_nb/` + `_zep/` with `_`-prefixed hardware sub-modules
- All hardware assets copied

### Phase 3: Base HM Modules ✓
- `common.nix` — persistence, activation, xsession, stateVersion
- `secrets.nix` — inline git config + access tokens
- `secrets/` — password hashes with `_`-prefixed nix files
- `shell-templates/` — mkenv script with `_`-prefixed template files
- `plasmaa0.nix` — user entry with 9 group imports

### Phase 4: CLI Group (13 files → `flake.homeModules.cli`) ✓
Editor (helix + markdown-oxide), shell (fish + starship), terminal (alacritty + kitty + wezterm), utils (btop + direnv + git + fastfetch + yazi), packages

### Phase 5: Desktop Group (8 files → `flake.homeModules.desktop`) ✓
i3 (inlined content, no aggregator), betterlockscreen, polybar, picom, dunst, rofi, conky, eww

### Phase 6: Applications Group (18 files → `flake.homeModules.applications`) ✓
Browser, social, music, editor, media, games, utils

### Phase 7: Services + Dev Groups (9 files → `flake.homeModules.services` + `flake.homeModules.dev`) ✓

### Phase 8: Non-Nix Assets ✓
60+ files: eww scripts/images, polybar configs/scripts, rofi themes/launchers/powermenu/todo, conky.conf, wezterm.lua, yazi plugins, rmpc images/scripts, fastfetch NixOS.png, shell templates

---

## Remaining Work / Next Steps

### 1. Build Verification

Run the new config to verify it evaluates:

```bash
nix build '.#nixosConfigurations.zep.config.system.build.toplevel' \
  --flake /home/plasmaa0/home-manager/configuration/flake-new.nix
```

### 2. Potential Issues to Check

- **`inputs` availability** in modules referencing `inputs.helix`, `inputs.yazi`, etc. — must be in `extraSpecialArgs`/`specialArgs`
- **`self.homeModules.stylix` circular reference** in `stylix.nix` — works via deferred module, but needs verification
- **Missing option declarations** — `mime.enable`, `hidpi.*` options declared in some modules but relied on by others
- **`config.hidpi.*` consumers** — `displayManager.nix`, `autorandr.nix` reference `config.hidpi.*` declared by `HighDPI.nix` — check import ordering
- **`_generate-theme-preview.nix` import path** from `stylix.nix` via `../home/_generate-theme-preview.nix` — verify resolution
- **Host secret paths** — `nb.nix`/`zep.nix` use `../home/secrets/` — resolves from `modules/nixos/` to `modules/home/secrets/`

### 3. Old File Cleanup (after verification)

```bash
rm -rf configuration/hosts configuration/homes configuration/mkSystem.nix
cp configuration/flake-new.nix configuration/flake.nix
rm configuration/flake-new.nix
```

### 4. Optional Improvements

- **Grouped imports further**: Some host-specific features (ollama, weylus) only imported by zep — could use subgroup keys
- **Option declarations**: Add explicit `options.*` for cross-module config (mime, hidpi)
- **Theme modularization**: Split `themes/` into `_`-prefixed nix files under `modules/nixos/themes/`

---

## Transition Procedure

1. Build-test the new config:

   ```bash
   nix build '.#nixosConfigurations.zep.config.system.build.toplevel' \
     --flake /home/plasmaa0/home-manager/configuration/flake-new.nix
   ```

2. If successful, activate the new flake:

   ```bash
   cp configuration/flake-new.nix configuration/flake.nix
   ```

3. Delete old structure:

   ```bash
   rm -rf configuration/hosts configuration/homes configuration/mkSystem.nix
   ```

4. Build and reboot:

   ```bash
   just rebuild-boot
   ```
