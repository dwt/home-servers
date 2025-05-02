{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  # To have specific secrets from the different secrets file
  # https://github.com/Mic92/sops-nix?tab=readme-ov-file#different-file-formats
  # set their `sopsFile` to a nix path
  sops.defaultSopsFile = ../secrets.yaml;
}
