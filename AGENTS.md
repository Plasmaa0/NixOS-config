# Agent Instructions for Home Manager Config

## Entry Point & Auto-Discovery

`configuration/flake.nix` calls `importTree(./modules)` → `mkFlake` (flake-parts). Every non-`_`-prefixed `.nix` file under `modules/` is recursively auto-imported. Files prefixed with `_` must be manually imported (helpers, split modules, hardware configs). Directories named with `_` are fine (Nix ignores dirs here).

## Module Structure

```
configuration/modules/
├── parts.nix          # systems (x86_64-linux, aarch64-linux), allowUnfree pkgs
├── devshell.nix       # devshell with just, fd, alejandra, statix, deadnix, opencode
├── secrets/           # sops-nix — standalone age keys (NOT SSH-key derivation)
│   ├── default.nix    # exports nixosModules.secrets + homeModules.secrets
│   ├── init.sh        # bootstrap script
│   └── secrets.yaml   # SOPS-encrypted (admin + machine keys)
├── hosts/{zep,nb}/    # per-host nixosConfigurations
├── users/plasmaa0.nix # homeModules.plasmaa0 — imports ~55 homeModules.*
└── features/          # ALL feature modules (NixOS + HM)
    ├── *.nix          # flat NixOS-only modules (bluetooth, bootloader, etc.)
    ├── cli/           # homeModules.cli-*
    ├── desktop/       # homeModules.desktop-*
    ├── applications/  # homeModules.application-*
    ├── services/      # homeModules.service-*
    ├── dev/           # homeModules.dev-*
    ├── stylix/        # dual-export: nixosModules.stylix + homeModules.stylix
    └── nix/           # nixosModules.autoUpgrade, garbageCollect, nix-ld
```

## Export Convention

| Type | Pattern | Example |
|------|---------|---------|
| NixOS module (flat file) | `nixosModules.<name>` | `bluetooth.nix` → `nixosModules.bluetooth` |
| HM module (dir/default.nix) | `homeModules.<category>-<subcategory>-<name>` | `cli/editor/helix/` → `homeModules.cli-editor-helix` |
| Dual export (1 file) | both keys in same file | `stylix/stylix.nix`, `secrets/default.nix` |

For dual-export modules, include the HM module in NixOS via `home-manager.sharedModules = [ self.homeModules.<name> ]`.

## Theming

`configuration/themes/<polarity>/<name>.nix` — pure data (no function wrapper):
```nix
{ wallpaper = "kyoto.jpg"; polarity = "dark"; scheme = "mocha"; }
```
- `polarity`: `"dark"` or `"light"`
- `scheme`: Base16 scheme name (omit to auto-generate from wallpaper pixels — worse contrast)
- `wallpaper`: filename in `configuration/wallpapers/`

The active theme is imported by `features/stylix/stylix.nix`. Switch themes by changing that import and running `just rebuild-switch`.

## Build Commands

All via `just`. Commands copy `configuration/*` → `/etc/nixos` then run `nixos-rebuild` against `/etc/nixos`.

```
just rebuild-boot            # all-checks → cp → nixos-rebuild boot
just rebuild-switch          # all-checks → cp → nixos-rebuild switch
just rebuild-test            # all-checks → cp → nixos-rebuild test
just rebuild-update          # update flake.lock → rebuild-boot
just rebuild-*-specific HOST  # same, but with --flake /etc/nixos#HOST
just all-checks              # format → check_dead → lint
just format                  # just --fmt + alejandra *.nix
just gc                      # nix-collect-garbage -d + switch-to-config boot
```

`all-checks` runs: `just --fmt --unstable` + `alejandra --quiet $(fd --extension nix)` then `deadnix` then `statix check`.

## Critical Gotchas

- **New `.nix` files must be `git add`-ed** before `nix build`/`eval` (git+file:// ignores untracked).
- **`users.mutableUsers = false`** — set in `features/impermanence.nix`; runtime `passwd` won't work.
- **`allowUnfree`** set in `parts.nix`; hosts also set it (redundant, harmless).
- **`specialArgs = { inherit inputs self; }`** in host `nixosSystem`; **`extraSpecialArgs = { inherit inputs self; }`** + `useGlobalPkgs = true` in host `home-manager`.
- Host modules import all needed `self.nixosModules.*` explicitly via `with self.nixosModules; [...]`.
- `_`-prefixed filenames are excluded from auto-import — use for split modules, helpers, hardware configs. No `_` on dir names.
- `.envrc` uses `use flake ./configuration` — `direnv allow` to enter the devshell.
- statix disables `repeated_keys` and `empty_pattern` checks (see `statix.toml`).

## Secrets (sops-nix)

`configuration/modules/secrets/default.nix`:
- **Machine key:** auto-generated at `/var/lib/sops-nix/key.txt` (`generateKey = true`); persisted via impermanence.
- **Admin key:** `~/.config/sops/age/keys.txt`; persisted via `home.homeModules.secrets`.
- **`.sops.yaml`** lists both `&admin` and `&machine` as recipients.
- **Passwords:** `neededForUsers = true` decrypts before user activation step.
- **Edit secrets:** `sops configuration/modules/secrets/secrets.yaml`.
- **Bootstrap:** `sudo configuration/modules/secrets/init.sh`.
- GitHub token is injected via `system.activationScripts` (sops decrypts at activation, not build time).
