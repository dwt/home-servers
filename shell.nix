{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs.buildPackages; [
    nixos-rebuild
    nix-output-monitor
    sops
    git
    # tio
  ];
}
