#!/bin/sh

set -e

nixos-rebuild build \
    --fast \
    --flake .#pi-lix \
    --build-host pi \
    --target-host pi \
    --use-remote-sudo

OUT_PATH=$(nix eval --raw \
    .#nixosConfigurations.pi-nix.config.system.build.toplevel.outPath
)

ssh pi \
      nix run nixpkgs#nix-diff -- \
      /run/current-system \
      $OUT_PATH \
      --color always
