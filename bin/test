#!/bin/sh

nixos-rebuild test \
    --fast \
    --flake .#pi-nix \
    --build-host pi \
    --target-host pi \
    --use-remote-sudo
