#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nixos-rebuild

    # --build-host pi \
nixos-rebuild test \
    --fast \
    --flake .#pi-nix \
    --target-host pi \
    --use-remote-sudo
