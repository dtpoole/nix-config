#!/usr/bin/env just --justfile

user := env('USER')
host := `hostname -s`

alias develop := shell
alias hm := home-manager
alias fmt := format

# switch the NixOS/nix-darwin configuration
default: switch

### linux
# build the NixOS configuration without switching to it
[linux]
build target_host=host flags="":
    @nh os build .

# switch the NixOS configuration
[linux]
switch target_host=host:
    @nh os switch --ask .

# build the NixOS config with the --show-trace flag set
[linux]
trace target_host=host: (build target_host "--show-trace")

# switch the home-manager configuration
[linux]
home-manager: _home-manager


### macos
# build the nix-darwin system configuration
[macos]
build target_host=host flags="":
    darwin-rebuild build --flake .#{{ target_host }} {{ flags }}

# build the nix-darwin configuration and switch to it
[macos]
switch target_host=host: (build target_host)
    darwin-rebuild switch --flake .#{{ target_host }}

# build the nix-darwin config with the --show-trace flag set
[macos]
trace target_host=host: (build target_host "--show-trace")

# switch the home-manager configuration
[macos]
home-manager: _home-manager

_home-manager:
    home-manager switch --flake .#{{ user }}@{{ host }}

# invoke a Nix shell
shell:
    nix --experimental-features 'nix-command flakes' develop

# update flake inputs to latest revisions and update pre-commit hooks
update:
    @nix flake update
    pre-commit autoupdate

# rekey agenix secrets
rekey:
    cd ./secrets && nix run github:ryantm/agenix -- --rekey

# format nix files in directory
format:
    nix fmt .

# run pre-commit hooks on all files
pre-commit:
    pre-commit run --all-files

# run nix linters
lint:
    @statix check -i .direnv
    @deadnix .

# clean up
cleanup:
    @nh clean all
