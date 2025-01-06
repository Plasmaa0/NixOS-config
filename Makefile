host ?= $(shell bash -c 'read -p "Host: " host; echo $$host')

all:
	@echo Available actions:
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo
	@$(MAKE) --quiet listHosts

listHosts:
	@echo Available hosts:
	@ls configuration/hosts -I common
	
gc:
	@echo -n "Are you sure? [y/N] " && read ans && \
	if [ $${ans:-'N'} = 'y' ]; then \
		sudo nix-collect-garbage --delete-older-than 5d; \
		nix-collect-garbage; \
	fi

check_dead:
	deadnix

format:
	@echo alejandra $$\(fd .nix\)
	@alejandra --quiet $$(fd .nix)

lint:
	statix check

all-checks: format check_dead lint

make-configuration:
	sudo rm /etc/nixos/* -rf
	sudo cp configuration/* /etc/nixos -r

rebuild-boot: all-checks make-configuration
	sudo nixos-rebuild boot --flake /etc/nixos --show-trace
rebuild-boot-specific: all-checks make-configuration listHosts
	sudo nixos-rebuild boot --flake /etc/nixos#$(host) --show-trace

rebuild-switch: all-checks make-configuration
	sudo nixos-rebuild switch --flake /etc/nixos --show-trace
rebuild-switch-specific: all-checks make-configuration listHosts
	sudo nixos-rebuild switch --flake /etc/nixos#$(host) --show-trace

rebuild-test: all-checks make-configuration
	sudo nixos-rebuild test --flake /etc/nixos --show-trace
rebuild-test-specific: all-checks make-configuration listHosts
	sudo nixos-rebuild test --flake /etc/nixos#$(host) --show-trace

rebuild-update: all-checks make-configuration
	sudo nix-channel --update
	sudo nixos-rebuild boot --flake /etc/nixos --upgrade --show-trace
rebuild-update-specific: all-checks make-configuration listHosts
	sudo nix-channel --update
	sudo nixos-rebuild boot --flake /etc/nixos#$(host) --upgrade --show-trace

cloc: format
	@# rofi       .rasi     -> .css
	@# dev shells .template -> .nix
	@# picom      .conf     -> .ini
	@# eww        .yuck     -> .lisp
	@cloc \
	  --force-lang=css,rasi \
	  --force-lang=nix,template \
	  --force-lang=ini,conf \
	  --force-lang=lisp,yuck \
	  .

create-host:
	$(eval host_name := $(host))
	mkdir -p configuration/hosts/$(host_name)/hardware
	touch configuration/hosts/$(host_name)/default.nix
	touch configuration/hosts/$(host_name)/hardware/hardware-configuration.nix
	@echo Created empty host directory \'$(host_name)\' in configuration/hosts
	
