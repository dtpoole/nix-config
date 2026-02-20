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
build target_host=host:
    nh os build . --hostname {{ target_host }}

# switch the NixOS configuration
[linux]
switch target_host=host:
    nh os switch --ask . --hostname {{ target_host }}

# build the NixOS config with the --show-trace flag set
[linux]
trace target_host=host:
    nh os build . --hostname {{ target_host }} -t

# set config as next boot default without activating
[linux]
boot target_host=host:
    nh os boot . --hostname {{ target_host }}

# rollback to previous generation
[linux]
rollback:
    nh os rollback

# load NixOS config in a Nix REPL
[linux]
repl target_host=host:
    nh os repl . --hostname {{ target_host }}

# build remotely on pure and deploy to target host
[linux]
remote-build target_host build_host="pure" flags="":
    nixos-rebuild build --flake .#{{ target_host }} \
        --build-host {{ build_host }} \
        --target-host {{ target_host }} \
        {{ flags }}

# build remotely and switch on target host
[linux]
remote-deploy target_host build_host="pure":
    nixos-rebuild switch --flake .#{{ target_host }} \
        --build-host {{ build_host }} \
        --target-host {{ target_host }} \
        --sudo \
        --ask-sudo-password

# switch the home-manager configuration
[linux]
home-manager: _home-manager


### macos
# build the nix-darwin system configuration
[macos]
build target_host=host:
    nh darwin build . --hostname {{ target_host }}

# build the nix-darwin configuration and switch to it
[macos]
switch target_host=host:
    nh darwin switch --ask . --hostname {{ target_host }}

# build the nix-darwin config with the --show-trace flag set
[macos]
trace target_host=host:
    nh darwin build . --hostname {{ target_host }} -t

# load nix-darwin config in a Nix REPL
[macos]
repl target_host=host:
    nh darwin repl . --hostname {{ target_host }}

# switch the home-manager configuration
[macos]
home-manager: _home-manager

_home-manager:
    nh home switch . --ask -c {{ user }}@{{ host }}

# invoke a Nix shell
shell:
    nix --experimental-features 'nix-command flakes' develop

# update flake inputs to latest revisions and update pre-commit hooks
update:
    @nix flake update
    pre-commit autoupdate

# update nvf-config flake input to latest revision
update-nvf:
    @nix flake update nvf-config

# rekey agenix secrets
rekey:
    cd ./secrets && nix run ..#agenix -- --rekey

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

# validate all flake outputs
check:
    nix flake check

# show all flake outputs
show:
    nix flake show

# clean up old generations and run gc
cleanup:
    nh clean all --ask
    direnv reload

# clean up and optimize nix store (slow, run occasionally)
optimize:
    nh clean all --ask --optimise
    direnv reload
