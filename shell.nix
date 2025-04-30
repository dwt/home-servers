{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs.buildPackages; [
    nixos-rebuild
    nix-output-monitor
    age
    sops
    git
    pv # show progress in shell pipes
    # tio # serial console
  ];
}
