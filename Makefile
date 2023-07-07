USER=$(shell whoami)
HOST=$(shell hostname -s)

shell:
	nix --extra-experimental-features "nix-command flakes" develop

switch-os:
	nixos-rebuild switch --use-remote-sudo --flake .#${HOST} -L

boot:
	nixos-rebuild boot --use-remote-sudo --flake .#${HOST} -L

test:
	nixos-rebuild test --use-remote-sudo --flake .#${HOST} -L

switch:
	home-manager switch --flake .#$(USER)@$(HOST)

update:
	nix flake update

format:
	nixpkgs-fmt *.nix home/*.nix home/*/*.nix

cleanup:
	nix-collect-garbage -d

upgrade:
	make update && make switch
