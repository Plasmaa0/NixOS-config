# Agent Instructions for Nix Configuration

## Project Overview

This is a NixOS + home-manager configuration managed as a **dendritic flake-parts** module tree. The goal of the refactoring (in progress on branch `dendritic`) is to replace the old flat aggregator-style config with a fully dendritic pattern where every `.nix` file is a self-contained flake-parts module.

**Two configs coexist:**
- **Old (production):** `configuration/flake.nix` → `mkSystem.nix` → `hosts/` + `homes/` — currently used for builds
- **New (refactored):** `configuration/flake-new.nix` → `importTree(./modules)` → `modules/` — not yet activated

## Repository Structure

```
/home/plasmaa0/home-manager/
├── justfile                          # Build commands (rebuild-boot, etc.)
├── AGENTS.md                         # This file
├── configuration/
│   ├── flake.nix                     # OLD entry point (production)
│   ├── flake-new.nix                 # NEW entry point (refactored, not yet active)
│   ├── mkSystem.nix                  # OLD builder (production)
│   ├── PLAN.md                       # Full reference, file inventory, how-to guide
│   ├── hosts/                        # OLD NixOS configs (to be deleted after transition)
│   ├── homes/                        # OLD HM configs (to be deleted after transition)
│   ├── modules/                      # NEW flake-parts module tree
│   ├── themes/                       # Theme color schemes (unchanged)
│   └── wallpapers/                   # Wallpaper images (unchanged)
```

## Key Files for AI Agents

### Entry Points
- **`configuration/flake-new.nix`** — New flake entry point. Custom `importTree` function using `lib.fileset.fileFilter`. Auto-discovers all `.nix` files in `./modules` (excluding `_*` and `flake.nix`).
- **`configuration/modules/parts.nix`** — Declares `systems`, imports `inputs.home-manager.flakeModules.home-manager`, sets `allowUnfree` pkgs config.

### Documentation (MUST READ before modifications)
- **`configuration/PLAN.md`** — COMPLETE REFERENCE. Contains: architecture, build instructions, complete file inventory (every module with export keys), conventions, how-to guides, transition procedure, troubleshooting.

### Key Pattern Files
| File | What it demonstrates |
|---|---|
| `modules/nixos/nb.nix` | Host module pattern: imports 29 `self.nixosModules.*`, defines users, home-manager wiring, exports `nixosModules.nb` + `nixosConfigurations.nb` |
| `modules/nixos/stylix.nix` | Dual-export pattern: both `nixosModules.stylix` and `homeModules.stylix` in one file |
| `modules/home/plasmaa0.nix` | User module pattern: imports 9 group modules via `self.homeModules.*` |
| `modules/home/applications/browser/qutebrowser.nix` | Simple grouped-key HM module: exports `flake.homeModules.applications` |
| `modules/home/cli/editor/helix/default.nix` | Directory module with `_`-prefixed splits: imports `_theme.nix`, `_settings/*`, `_languages/*` |

## Critical Conventions

### DO
- Place all new `.nix` files inside `configuration/modules/`
- Export `flake.nixosModules.*` for NixOS modules
- Export `flake.homeModules.*` for HM modules
- Use `_` prefix for split sub-modules (files that are manually imported by a parent)
- List ALL `self.nixosModules.*` dependencies explicitly in host modules
- List ALL group `self.homeModules.*` imports explicitly in user modules
- Use `with self.nixosModules; [...]` in host modules for readability
- Pass `specialArgs = { inherit inputs self; }` to `nixosSystem`
- Pass `extraSpecialArgs = { inherit inputs self; }` to `home-manager`
- Inline all content — NO `import` references to old `homes/` or `hosts/` files

### DO NOT
- Create `_`-prefixed **directory** names (only file names)
- Create aggregator modules that just re-export other modules
- Reference `import ../homes/...` or `import ../hosts/...` in new modules
- Add `nixpkgs.config.allowUnfree` in individual modules (handled centrally in `parts.nix`)
- Touch old `hosts/` or `homes/` directories (they remain for production use until transition)
- Store secrets in plain `.nix` files without `_` prefix (they'd be auto-imported)

## Grouped HM Keys (Dendritic Merge)

Multiple files in the same directory export the **same** `flake.homeModules.*` key. Flake-parts merges them into one module:

| Directory | Shared key | Files |
|---|---|---|
| `modules/home/cli/` | `flake.homeModules.cli` | 13 files (helix, fish, starship, terminals, utils) |
| `modules/home/desktop/common/` | `flake.homeModules.desktop` | 8 files (i3, polybar, rofi, picom, dunst, conky, eww, betterlockscreen) |
| `modules/home/applications/` | `flake.homeModules.applications` | 18 files (browsers, music, editors, media, games) |
| `modules/home/services/` | `flake.homeModules.services` | 6 files |
| `modules/home/dev/` | `flake.homeModules.dev` | 3 files |

Standalone keys: `common`, `secrets`, `shell-templates`, `stylix`, `plasmaa0`

NixOS modules are all unique keys — no sharing.

## Build & Test Commands

```bash
# Production build (uses old config):
just rebuild-boot

# Test-build new refactored config:
nix build '.#nixosConfigurations.zep.config.system.build.toplevel' \
  --flake /home/plasmaa0/home-manager/configuration/flake-new.nix

# Check evaluation:
nix flake check --flake /home/plasmaa0/home-manager/configuration/flake-new.nix

# Format code:
just format

# Run all checks:
just all-checks
```

## Common Mistakes

### Mistake 1: Using `_` prefix on directories
Wrong: `modules/home/cli/_editor/helix/`
Right: `modules/home/cli/editor/helix/`
The `_` prefix is only for file names, never directory names.

### Mistake 2: Creating aggregator modules
Wrong: Creating `modules/home/applications/default.nix` that imports other files.
Right: Each file under `applications/` exports `flake.homeModules.applications` independently.

### Mistake 3: Forgetting to add `self.nixosModules.*` to host import lists
NixOS modules are NOT auto-discovered — hosts must explicitly import each one they need.

### Mistake 4: Missing `self`/`inputs` in `specialArgs`
If a NixOS module uses `self.nixosModules.*` or `inputs.*`, the host `nixosSystem` call must include `specialArgs = { inherit inputs self; }`.

### Mistake 5: Path errors for secrets
Host modules reference `../home/secrets/_plasmaa0_password.nix` — this resolves from `modules/nixos/`. If the file moves, update all host modules.

## Transition Checklist (for final activation)

- [ ] Run `nix flake check --flake configuration/flake-new.nix` — succeeds
- [ ] Run `nix build '.#nixosConfigurations.zep...' --flake configuration/flake-new.nix` — succeeds  
- [ ] Run `nix build '.#nixosConfigurations.nb...' --flake configuration/flake-new.nix` — succeeds
- [ ] `cp configuration/flake-new.nix configuration/flake.nix`
- [ ] `rm -rf configuration/hosts/ configuration/homes/ configuration/mkSystem.nix`
- [ ] Remove `import-tree` input from `flake.nix`
- [ ] `nix flake lock --flake configuration/`
- [ ] `just rebuild-boot` — succeeds
