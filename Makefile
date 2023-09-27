USER=$(shell whoami)
HOST=$(shell hostname -s)
DISTRIBUTION := $(shell grep -s '^ID=' /etc/os-release | cut -d= -f2 )
UNAME := $(shell uname -s)

ifeq ($(DISTRIBUTION), nixos)
switch::
	nixos-rebuild switch --use-remote-sudo --flake .#${HOST} -L
else ifeq ($(UNAME), Darwin)
switch::
	nix run nix-darwin -- switch --flake .#${HOST} -L
else
switch::
	home-manager switch --flake .#$(USER)@$(HOST)
endif

shell:
	nix --extra-experimental-features "nix-command flakes" develop

boot:
	nixos-rebuild boot --use-remote-sudo --flake .#${HOST} -L

test:
	nixos-rebuild test --use-remote-sudo --flake .#${HOST} -L

darwin:
	nix run nix-darwin -- switch --flake .#${HOST} -L

update:
	nix flake update

format:
	nixpkgs-fmt .

pre-commit:
	pre-commit run --all-files

cleanup:
	nix-collect-garbage -d

upgrade:
	make update && make switch
