#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nixos-rebuild

nixos-rebuild test \
    --fast \
    --flake .#pi-nix \
    --build-host pi \
    --target-host pi \
    --use-remote-sudo
