USER=$(shell whoami)
HOST=$(shell hostname -s)

shell:
	nix --extra-experimental-features "nix-command flakes" develop

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
