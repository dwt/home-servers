{
  system,
  inputs,
  pkgs,
}:
let
  inherit (inputs.self.checks.${system}.pre-commit-check) shellHook enabledPackages;
in
pkgs.mkShell {
  inherit shellHook;
  buildInputs = enabledPackages;
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
