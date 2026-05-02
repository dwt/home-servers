{
  system,
  inputs,
  pkgs,
}:
let
  inherit (inputs.self.checks.${system}.pre-commit-check) shellHook enabledPackages;
  lib = pkgs.callPackage ./lib { };

in
pkgs.mkShell {
  inherit shellHook;
  buildInputs = enabledPackages;
  packages = with pkgs; [
    (lib.mkPkgs inputs.nixpkgs-unstable).lixPackageSets.latest.nixos-rebuild-ng
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
