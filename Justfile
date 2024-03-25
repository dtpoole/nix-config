#!/usr/bin/env just --justfile

user := env('USER')
host := `hostname -s`

alias develop := shell
alias hm := home-manager

# Switch the NixOS/nix-darwin configuration
default: switch

### linux
# Build the NixOS configuration without switching to it
[linux]
build target_host=host flags="":
    nixos-rebuild build --flake .#{{ target_host }} {{ flags }}

# Switch the NixOS configuration
[linux]
switch target_host=host:
    nixos-rebuild switch --use-remote-sudo --flake .#{{ target_host }}

# Build the NixOS config with the --show-trace flag set
[linux]
trace target_host=host: (build target_host "--show-trace")

# Switch the home-manager configuration
[linux]
home-manager: _home-manager


### macos
# Build the nix-darwin system configuration
[macos]
build target_host=host flags="":
    darwin-rebuild build --flake .#{{ target_host }} {{ flags }}

# Build the nix-darwin configuration and switch to it
[macos]
switch target_host=host: (build target_host)
    darwin-rebuild switch --flake .#{{ target_host }}

# Build the nix-darwin config with the --show-trace flag set
[macos]
trace target_host=host: (build target_host "--show-trace")

# Switch the home-manager configuration
[macos]
home-manager: _home-manager

_home-manager:
    home-manager switch --flake .#{{ user }}@{{ host }}

# Invoke a Nix shell
shell:
    nix --experimental-features 'nix-command flakes' develop

# Update flake inputs to latest revisions and update pre-commit hooks
update:
    nix flake update
    pre-commit autoupdate

# rekey agenix secrets
rekey:
    cd ./secrets && agenix --rekey

# Format nix files in directory
format:
    nixpkgs-fmt .

# Run pre-commit hooks on all files
pre-commit:
    pre-commit run --all-files

# Clean up
cleanup generations="5d":
    nix-env --delete-generations {{ generations }}
    nix-store --gc
    rm -rf ./result
