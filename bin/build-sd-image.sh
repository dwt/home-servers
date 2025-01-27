#!/usr/bin/env bash

NIX_DISTRIBUTION=${NIX_DISTRIBUTION:-lix}

# build image
nix build \
    --print-build-logs \
    ".#nixosConfigurations.pi-$NIX_DISTRIBUTION.config.system.build.sdImage" \
    2>&1 | nom

# copy image out of nix store
cp result/sd-image/nixos-sd-image*.img nixos-sd.img

# then flash to sd card with something like
# pv <image> | sudo dd of=/dev/sdX bs=10M status=progress
# to manually update the system should be possible with something like
# nixos-rebuild switch --flake .#pi-nix --target-host pi.local --build-host pi.local
