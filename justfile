[private]
default:
    @echo -n {{ GREEN + BOLD }}
    @just --list

# deadnix check
[group('checks')]
@check_dead:
    echo "{{ GREEN + INVERT }}Check:{{ NORMAL }}"
    echo -e "{{ CYAN }}\t- checking with {{ BLUE + ITALIC }}deadnix{{ NORMAL }}"
    deadnix --exclude configuration/homes/common/shell_templates/template_*

# alejandra format .nix files
[group('checks')]
@format:
    echo "{{ GREEN + INVERT }}Format:{{ NORMAL }}"
    echo -e "{{ CYAN }}\t- formatting justfile{{ NORMAL }}"
    just --fmt --unstable
    echo -e "{{ CYAN }}\t- formatting {{ BLUE + UNDERLINE }}*.nix{{ NORMAL }}{{ CYAN }} with {{ BLUE + ITALIC }}alejandra{{ NORMAL }}"
    alejandra --quiet $(fd --extension nix)

# statix linter
[group('checks')]
@lint:
    echo -e "{{ CYAN }}\t- checking with {{ BLUE + ITALIC }}statix{{ NORMAL }}"
    statix check

# Run all checks
[group('checks')]
all-checks: format check_dead lint

# Make configuration
[private]
@make-configuration:
    echo "{{ GREEN + INVERT }}Build:{{ NORMAL }}"
    echo -e "{{ CYAN }}\t- cleaning {{ BLUE + UNDERLINE }}/etc/nixos/*{{ NORMAL }}"
    sudo rm -rf /etc/nixos/*
    echo -e "{{ CYAN }}\t- moving your new config to {{ BLUE + UNDERLINE }}/etc/nixos{{ NORMAL }}"
    sudo cp -r configuration/* /etc/nixos

# Rebuild boot configurations
[group('rebuild boot')]
@rebuild-boot: all-checks make-configuration
    echo -e "{{ CYAN }}\t- rebuilding config {{ RED + UNDERLINE }}(boot){{ NORMAL }}"
    sudo nixos-rebuild boot --flake /etc/nixos --show-trace
    echo "{{ GREEN + INVERT }}Done!{{ NORMAL }}"

# Rebuild boot configurations for a specific host
[group('rebuild boot')]
@rebuild-boot-specific host: listHosts all-checks make-configuration
    echo -e "{{ CYAN }}\t- rebuilding config {{ RED + UNDERLINE }}(boot){{ NORMAL }}{{ CYAN }} for host{{ YELLOW }} {{ host }}"
    sudo nixos-rebuild boot --flake /etc/nixos#{{ host }} --show-trace
    echo "{{ GREEN + INVERT }}Done!{{ NORMAL }}"

# Rebuild switch configurations
[group('rebuild switch')]
@rebuild-switch: all-checks make-configuration
    echo -e "{{ CYAN }}\t- rebuilding config {{ GREEN + UNDERLINE }}(switch){{ NORMAL }}"
    sudo nixos-rebuild switch --flake /etc/nixos --show-trace
    echo "{{ GREEN + INVERT }}Done!{{ NORMAL }}"

# Rebuild switch configurations for a specific host
[group('rebuild switch')]
@rebuild-switch-specific host: listHosts all-checks make-configuration
    echo -e "{{ CYAN }}\t- rebuilding config {{ GREEN + UNDERLINE }}(switch){{ NORMAL }}{{ CYAN }} for host{{ YELLOW }} {{ host }}"
    sudo nixos-rebuild switch --flake /etc/nixos#{{ host }} --show-trace
    echo "{{ GREEN + INVERT }}Done!{{ NORMAL }}"

# Rebuild test configurations
[group('rebuild test')]
@rebuild-test: all-checks make-configuration
    echo -e "{{ CYAN }}\t- rebuilding config {{ WHITE + UNDERLINE }}(test){{ NORMAL }}"
    sudo nixos-rebuild test --flake /etc/nixos --show-trace
    echo "{{ GREEN + INVERT }}Done!{{ NORMAL }}"

# Rebuild test configurations for a specific host
[group('rebuild test')]
@rebuild-test-specific host: listHosts all-checks make-configuration
    echo -e "{{ CYAN }}\t- rebuilding config {{ WHITE + UNDERLINE }}(test){{ NORMAL }}{{ CYAN }} for host{{ YELLOW }} {{ host }}"
    sudo nixos-rebuild test --flake /etc/nixos#{{ host }} --show-trace
    echo "{{ GREEN + INVERT }}Done!{{ NORMAL }}"

# Update configurations
[group('rebuild update')]
@rebuild-update: updateFlakeLock
    echo -e "{{ CYAN }}\t- rebuilding {{ YELLOW + BOLD }}and updating{{ NORMAL }}{{ CYAN }} config {{ RED + UNDERLINE }}(boot){{ NORMAL }}"
    just rebuild-boot
    echo "{{ GREEN + INVERT }}Update done!{{ NORMAL }}"

# Update configurations for a specific host
[group('rebuild update')]
@rebuild-update-specific host: updateFlakeLock
    echo -e "{{ CYAN }}\t- rebuilding {{ YELLOW + BOLD }}and updating{{ NORMAL }}{{ CYAN }} config {{ RED + UNDERLINE }}(boot){{ NORMAL }}{{ CYAN }} for host{{ YELLOW }} {{ host }}"
    just rebuild-boot-specific {{ host }}
    echo "{{ GREEN + INVERT }}Update done!{{ NORMAL }}"

# List available hosts
[group('util')]
@listHosts:
    echo "{{ BOLD + BLUE + INVERT }}Available hosts:{{ NORMAL }}{{ CYAN }}"
    ls configuration/hosts -I common

backupFile := "flake_$(date '+%d-%m-%Y_%H-%M-%S').lock"

# Update flake.lock
[group('util')]
@updateFlakeLock:
    echo "{{ GREEN + INVERT }}Update:{{ NORMAL }}"
    cp configuration/flake.lock {{ backupFile }}
    echo -e "{{ CYAN }}\t- {{ BLUE + UNDERLINE }}./configuration/flake.lock{{ NORMAL }}{{ CYAN }} backup is at {{ BLUE + UNDERLINE }}./{{ backupFile }}{{ NORMAL }}"
    echo -e "{{ CYAN }}\t- {{ GREEN }}updating {{ BLUE + UNDERLINE }}flake.lock{{ NORMAL }}"
    @nix flake update --flake configuration/
    echo -e "{{ CYAN }}\t- flake.lock updated"

# Garbage collection
[confirm('Are you sure? [y/N]')]
[group('util')]
@gc:
    echo "{{ BOLD + RED }}Cleaning garbage{{ NORMAL }}"
    sudo nix-collect-garbage --delete-older-than 5d
    nix-collect-garbage

# Count lines of code
[group('util')]
@cloc: format
    echo "{{ BOLD + GREEN }}Counting lines of code!{{ NORMAL }}"
    # rofi       .rasi     -> .css
    # dev shells .template -> .nix
    # picom      .conf     -> .ini
    # eww        .yuck     -> .lisp
    cloc \
        --force-lang=css,rasi \
        --force-lang=nix,template \
        --force-lang=ini,conf \
        --force-lang=lisp,yuck \
        --progress-rate=1 \
        --exclude-ext=json \
        --exclude-list-file=.clocignore \
        --ignored=ignored.txt \
        --vcs=git \
        .
    echo "{{ BOLD + RED }}Ignored files:{{ NORMAL }}"
    cat ignored.txt
    rm ignored.txt

# Create a new host directory
[group('util')]
@create-host host:
    mkdir -p configuration/hosts/{{ host }}/hardware
    touch configuration/hosts/{{ host }}/default.nix
    touch configuration/hosts/{{ host }}/hardware/hardware-configuration.nix
    echo "{{ BOLD + GREEN }}Created empty host directory {{ BLUE + UNDERLINE }}{{ host }}{{ NORMAL }}{{ BOLD + GREEN }} in {{ BLUE + UNDERLINE }}configuration/hosts{{ NORMAL }}"

# Visualize memory used by nix derivations
[group('util')]
@memory:
    nix-shell -p nix-du graphviz --command "nix-du -n 40 | dot -Tsvg > store.svg"
    feh store.svg
    rm store.svg || true
    rm feh*.png || true
    nix-shell -p nix-du graphviz --command "nix-du --root /run/current-system/sw/ -n 40 | dot -Tsvg > store.svg"
    feh store.svg
    rm store.svg || true
    rm feh*.png || true
