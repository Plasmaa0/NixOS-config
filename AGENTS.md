# Agent Instructions for Home Manager Config

## Architecture

This is a **flake-parts** dendritic module tree. Entry point: `configuration/flake.nix` calls `importTree(./modules)` → `mkFlake`. Every non-`_` `.nix` file under `modules/` is auto-discovered as a flake-parts module.

**Old (backup, unused):** `flake-old.nix` → `mkSystem.nix` → `hosts/` + `homes/` — kept for reference, will be deleted.

## Directory Layout

```
configuration/modules/
├── parts.nix              # systems, home-manager flake module, pkgs with allowUnfree
├── devshell.nix           # devshell
├── secrets/
│   ├── default.nix        # nixosModules.secrets — sops-nix, passwords, GitHub token
│   └── secrets.yaml       # SOPS-encrypted (AGE key: age1wkq3uhx...)
├── hosts/
│   ├── zep/zep.nix        # nixosModules.zep + nixosConfigurations.zep
│   └── nb/nb.nix          # nixosModules.nb + nixosConfigurations.nb
├── users/
│   └── plasmaa0.nix       # homeModules.plasmaa0 — user entry, imports all feature modules
└── features/              # ALL feature modules (NixOS + HM mixed)
    ├── <feature>.nix      # flat files for simple features
    ├── cli/               # helix, fish, starship, terminals, utils
    ├── desktop/           # i3, polybar, rofi, picom, dunst, eww, etc.
    ├── applications/      # browsers, music, editors, media, games
    ├── services/          # flameshot, copyq, powertop, udiskie, etc.
    ├── dev/               # typst, latex, python
    ├── stylix/            # global + user stylix (exports both nixosModules and homeModules)
    └── nix/               # autoUpgrade, garbageCollect, nix-ld
```

## Export Key Convention

All modules export unique dash-separated hierarchical keys — NO shared/grouped keys:

| Pattern | Example |
|---|---|
| `nixosModules.<short-name>` | `impermanence`, `bluetooth`, `secrets`, `stylix` |
| `homeModules.<category>-<subcategory>-<name>` | `cli-editor-helix`, `application-browser-qutebrowser`, `desktop-window-manager-x11-i3` |

Full hierarchy: `cli` → `cli-utils-common`, `cli-editor-helix`, `cli-shell-fish`; `desktop` → `desktop-window-manager-x11-i3`, `desktop-bar-eww`; `application` → `application-browser-qutebrowser`, `application-music-mpd`, `application-util-mime`.

## Critical Conventions

- **`_` prefix on file names** = excluded from auto-import (split modules, hardware configs, helpers)
- **NO `_` prefix on directory names** (only files)
- **Host modules** (`hosts/<host>/<host>.nix`) import all needed `self.nixosModules.*` features explicitly + `./_hardware-configuration.nix`
- **User module** (`users/plasmaa0.nix`) imports all needed `self.homeModules.*` explicitly (~50+ imports)
- **Host `nixosSystem`** passes `specialArgs = { inherit inputs self; }`
- **Host `home-manager`** passes `extraSpecialArgs = { inherit inputs self; }` and `useGlobalPkgs = true`
- **`users.mutableUsers = false`** is set in `features/impermanence.nix` — runtime `passwd` won't work

## Secret Management (sops-nix)

**ACTIVE (new):** `modules/secrets/default.nix` — uses sops-nix. Encrypted secrets in `secrets.yaml` (AGE key `age1wkq3uhx...`). Passwords: `users.users.<name>.hashedPasswordFile` set from sops path. `neededForUsers = true` ensures decrypt before user activation.

**DEAD (old, unused):** `configuration/homes/common/secrets/` — contains old plaintext password `"REDACTED"` in `plasmaa0_password.nix`. The old `mkSystem.nix` used `password = import ...` but this path is no longer active.

**If passwords stop working:** Check that the SSH host key at `/etc/ssh/ssh_host_ed25519_key` (persisted via impermanence) matches the recipient in `secrets.yaml`. Run `ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub` and compare. To re-encrypt `secrets.yaml` for the machine's SSH key, see `modules/secrets/SECRETS.md`.

## Build Commands

```bash
just rebuild-boot        # all-checks → cp to /etc/nixos → nixos-rebuild boot
just rebuild-switch      # all-checks → cp → nixos-rebuild switch
just rebuild-test        # all-checks → cp → nixos-rebuild test
just all-checks          # format → check_dead → lint
just format              # alejandra *.nix + just --fmt
```

The `justfile` copies `configuration/*` to `/etc/nixos`, so both old dirs (`hosts/`, `homes/`) and new dirs (`modules/`) coexist on the target. The flake entry (`flake.nix`) only reads `modules/`.

## Git Caveats

- **`git+file://` fetcher ignores untracked files** — new `.nix` files in `modules/` must be `git add`-ed before `nix build`/`nix eval` will see them
- Submodules (wallpapers) need `?submodules=1` in git+file URL
