#!/usr/bin/env bash

cd /src

# enable flakes
mkdir -p ~/.config/nix/
cat > ~/.config/nix/nix.conf <<EOD
experimental-features = nix-command flakes
EOD

# build image
nix \
    build \
    --print-build-logs \
    ".#nixosConfigurations.pi-$NIX_DISTRIBUTION.config.system.build.sdImage"

# copy image out of nix store
OUT_PATH=$(nix eval --raw \
    .#nixosConfigurations.pi-$NIX_DISTRIBUTION.config.system.build.sdImage.outPath
)
cp $OUT_PATH/sd-image/nixos-sd-image*.img nixos-sd.img

# TODO copy out generated image
# then flash to sd card with something like
# pv <image> | sudo dd of=/dev/sdX bs=10M status=progress
# to manually update the system should be possible with something like
# nixos-rebuild switch --flake .#pi-nix --target-host pi.local --build-host pi.local
