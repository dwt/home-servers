{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs.buildPackages; [
    nixfmt-rfc-style
    nixos-rebuild
    nix-output-monitor
    sops
    git
    # tio
  ];
}
