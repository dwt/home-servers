{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    nixos-rebuild
    nix-output-monitor
    nvd
    age
    ssh-to-age
    sops
    git
    pv # show progress in shell pipes
    tio # serial console
  ];
}
