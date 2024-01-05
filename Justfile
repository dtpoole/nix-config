#!/usr/bin/env just --justfile

default: switch

user := env('USER')
host := `hostname -s`

alias develop := shell

### linux
# Build the NixOS configuration without switching to it
[linux]
build target_host=host flags="":
    nixos-rebuild build --flake .#{{ target_host }} {{ flags }}

# Switch the NixOS configuration
[linux]
switch target_host=host:
    nixos-rebuild switch --flake .#{{ target_host }} \

# Build the NixOS config with the --show-trace flag set
[linux]
trace target_host=host: (build target_host "--show-trace")

# Switch the home-manager configuration
[linux]
home-manager:
    home-manager switch --flake .#{{ user }}@{{ host }}


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
home-manager target_host=host:
    home-manager switch --flake .#{{ user }}@{{ host }}

# Invoke a Nix shell
shell:
    nix develop

# Update flake inputs to latest revisions
update:
    nix flake update

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
