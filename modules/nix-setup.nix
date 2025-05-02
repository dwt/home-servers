{ config, inputs, ... }:
{
  imports = [
    inputs.lix-module.nixosModules.default
  ];
  # Enable flakes and new 'nix' command
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Opinionated: disable global registry
  # nix.settings.flake-registry = "";
  # Workaround for https://github.com/NixOS/nix/issues/9574
  nix.settings.nix-path = config.nix.nixPath;
  nix.settings.trusted-users = [
    config.users.users.dwt.name
  ];
  # Opinionated: disable channels
  nix.channel.enable = false;

  # automatically prune no longer needed nix packages
  nix.gc.automatic = true;
}
