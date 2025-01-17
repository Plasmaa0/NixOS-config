[private]
default:
    @just --list

# deadnix check
[group('checks')]
check_dead:
    deadnix

# alejandra format .nix files
[group('checks')]
format:
    just --fmt --unstable
    @echo "alejandra \$(fd .nix)"
    alejandra --quiet $(fd .nix)

# statix linter
[group('checks')]
lint:
    statix check

# Run all checks
[group('checks')]
all-checks: format check_dead lint

# Make configuration
[private]
make-configuration:
    sudo rm -rf /etc/nixos/*
    sudo cp -r configuration/* /etc/nixos

# Rebuild boot configurations
[group('rebuild boot')]
rebuild-boot: all-checks make-configuration
    sudo nixos-rebuild boot --flake /etc/nixos --show-trace

# Rebuild boot configurations for a specific host
[group('rebuild boot')]
rebuild-boot-specific host: all-checks make-configuration listHosts
    sudo nixos-rebuild boot --flake /etc/nixos#{{ host }} --show-trace

# Rebuild switch configurations
[group('rebuild switch')]
rebuild-switch: all-checks make-configuration
    sudo nixos-rebuild switch --flake /etc/nixos --show-trace

# Rebuild switch configurations for a specific host
[group('rebuild switch')]
rebuild-switch-specific host: all-checks make-configuration listHosts
    sudo nixos-rebuild switch --flake /etc/nixos#{{ host }} --show-trace

# Rebuild test configurations
[group('rebuild test')]
rebuild-test: all-checks make-configuration
    sudo nixos-rebuild test --flake /etc/nixos --show-trace

# Rebuild test configurations for a specific host
[group('rebuild test')]
rebuild-test-specific host: all-checks make-configuration listHosts
    sudo nixos-rebuild test --flake /etc/nixos#{{ host }} --show-trace

# Update configurations
[group('rebuild update')]
rebuild-update: all-checks make-configuration
    sudo nix-channel --update
    sudo nixos-rebuild boot --flake /etc/nixos --upgrade --show-trace

# Update configurations for a specific host
[group('rebuild update')]
rebuild-update-specific host: all-checks make-configuration listHosts
    sudo nix-channel --update
    sudo nixos-rebuild boot --flake /etc/nixos#{{ host }} --upgrade --show-trace

# List available hosts
[group('util')]
@listHosts:
    echo "{{ BOLD + CYAN }}Available hosts:{{ NORMAL }}"
    ls configuration/hosts -I common

# Garbage collection
[confirm('Are you sure? [y/N]')]
[group('util')]
gc:
    sudo nix-collect-garbage --delete-older-than 5d
    nix-collect-garbage

# Count lines of code
[group('util')]
@cloc: format
    # rofi       .rasi     -> .css
    # dev shells .template -> .nix
    # picom      .conf     -> .ini
    # eww        .yuck     -> .lisp
    cloc \
        --force-lang=css,rasi \
        --force-lang=nix,template \
        --force-lang=ini,conf \
        --force-lang=lisp,yuck \
        .

# Create a new host directory
[group('util')]
create-host host:
    mkdir -p configuration/hosts/{{ host }}/hardware
    touch configuration/hosts/{{ host }}/default.nix
    touch configuration/hosts/{{ host }}/hardware/hardware-configuration.nix
    @echo "{{ BOLD + CYAN }}Created empty host directory '{{ host }}' in configuration/hosts{{ NORMAL }}"
