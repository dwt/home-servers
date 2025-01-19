#!/bin/sh

    # --fast \
    # --build-host rosetta-builder \
nixos-rebuild switch \
    --flake .#pi-nix \
    --target-host pi \
    --use-remote-sudo
