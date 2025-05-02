{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    nixos-rebuild
    nix-output-monitor
    age
    sops
    git
    pv # show progress in shell pipes
    # tio # serial console
  ];
}
