# Agent Instructions for Home Manager Config

## Architecture

Flake-parts dendritic module tree. Entry point: `configuration/flake.nix` calls `importTree(./modules)` → `mkFlake`. Every non-`_` `.nix` file under `modules/` is auto-discovered as a flake-parts module.

```
configuration/modules/
├── parts.nix         # systems (x86_64-linux, aarch64-linux), home-manager flake module, allowUnfree pkgs
├── devshell.nix      # devshell (alejandra, statix, deadnix, just, fd)
├── secrets/          # sops-nix (standalone age keys, NOT ssh-key derivation)
│   ├── default.nix   # exports nixosModules.secrets + homeModules.secrets
│   ├── init.sh       # bootstrap: generate keys, write .sops.yaml, encrypt secrets.yaml
│   └── secrets.yaml  # SOPS-encrypted (admin key + machine key)
├── hosts/{zep,nb}/   # per-host modules + nixosConfigurations
├── users/plasmaa0.nix # homeModules.plasmaa0 — imports ~55 homeModules.*
└── features/         # ALL feature modules (NixOS + HM)
    ├── *.nix         # flat files
    ├── cli/          # helix, fish, starship, terminals, utils
    ├── desktop/      # i3, polybar, rofi, picom, dunst, eww, conky
    ├── applications/ # browsers, music, editors, media, games, mime
    ├── services/     # flameshot, copyq, powertop, udiskie, poweralertd, kde-connect
    ├── dev/          # typst, latex, python
    ├── stylix/       # dual-export: nixosModules.stylix + homeModules.stylix
    └── nix/          # autoUpgrade, garbageCollect, nix-ld
```

**Dead code (on disk, not imported):** `configuration/flake-old.nix`, `configuration/mkSystem.nix`, `configuration/hosts/` (old flat style), `configuration/homes/` (contains plaintext password refs).

## Export Convention

| Type | Pattern | Example |
|------|---------|---------|
| NixOS module | `nixosModules.<short-name>` | `secrets`, `stylix`, `impermanence`, `bluetooth` |
| HM module | `homeModules.<category>-<subcategory>-<name>` | `cli-editor-helix`, `application-browser-qutebrowser` |
| HM+nixos dual (1 file) | both keys in same file | `stylix/stylix.nix`, `secrets/default.nix` |

A single file can export both `nixosModules.*` and `homeModules.*`. Include the HM module in the NixOS module via `home-manager.sharedModules = [ self.homeModules.<name> ]`.

## Critical Conventions

- **`_`-prefix on filenames** = excluded from auto-import (split modules, hardware configs, helpers). NO `_` on dir names.
- **Host modules** (`hosts/<host>/<host>.nix`) import all needed `self.nixosModules.*` explicitly with `with self.nixosModules; [...]` + `./_hardware-configuration.nix`
- **User module** (`users/plasmaa0.nix`) imports all needed `self.homeModules.*` explicitly (~55 imports)
- **Host `nixosSystem`** passes `specialArgs = { inherit inputs self; }`
- **Host `home-manager`** passes `extraSpecialArgs = { inherit inputs self; }` and `useGlobalPkgs = true`
- **`users.mutableUsers = false`** — set in `features/impermanence.nix`; runtime `passwd` won't work
- **`allowUnfree`** is set centrally in `parts.nix`; hosts also set it (redundant but harmless)
- **New `.nix` files must be `git add`-ed** before `nix build`/`eval` (git+file:// ignores untracked)

## Secret Management (sops-nix)

Defined in `modules/secrets/default.nix` — standalone age keys (NOT SSH-key derivation).

- **Machine key:** auto-generated at `/var/lib/sops-nix/key.txt` (`generateKey = true`); persisted via impermanence (`/var/lib/sops-nix` in `files` + `directories`)
- **Admin key:** at `~/.config/sops/age/keys.txt`; persisted via `homeModules.secrets` (`home.persistence`)
- **`.sops.yaml`** lists both `&admin` and `&machine` as recipients
- **Passwords config:** `neededForUsers = true` decrypts before user activation step
- **Bootstrap:** run `sudo configuration/modules/secrets/init.sh` to generate keys and create `secrets.yaml`
- **Edit secrets:** `cd configuration/modules/secrets && sops secrets.yaml`

## Build Commands

```bash
just rebuild-boot          # all-checks → cp to /etc/nixos → nixos-rebuild boot
just rebuild-switch        # all-checks → cp → nixos-rebuild switch
just rebuild-test          # all-checks → cp → nixos-rebuild test
just all-checks            # format → check_dead → lint
just format                # alejandra *.nix + just --fmt
```

The `justfile` copies `configuration/*` into `/etc/nixos`, so `nixos-rebuild` runs against `/etc/nixos`. The flake entry at `configuration/flake.nix` only reads `modules/`; old `hosts/`/`homes/` dirs on the target are dead.
