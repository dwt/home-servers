#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nixos-rebuild

nixos-rebuild switch \
    --fast \
    --flake .#pi-nix \
    --target-host pi \
    --build-host pi \
    --use-remote-sudo
