USER=$(shell whoami)
HOST=$(shell hostname -s)
UNAME := $(shell uname -a | grep NixOS)

ifeq ($(UNAME),)
switch::
	home-manager switch --flake .#$(USER)@$(HOST)
else
switch::
	nixos-rebuild switch --use-remote-sudo --flake .#${HOST} -L
endif

shell:
	nix --extra-experimental-features "nix-command flakes" develop

boot:
	nixos-rebuild boot --use-remote-sudo --flake .#${HOST} -L

test:
	nixos-rebuild test --use-remote-sudo --flake .#${HOST} -L

update:
	nix flake update

format:
	nixpkgs-fmt .

cleanup:
	nix-collect-garbage -d

upgrade:
	make update && make switch
