#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nixos-rebuild

set -e

nixos-rebuild build \
    --fast \
    --flake .#pi-nix \
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
