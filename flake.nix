{
  description = "Häckers NixOS Homeserver configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # lix - but doesn't work as of yet
    # See https://wiki.lix.systems/books/lix-contributors/page/lix-beta-guide
    # See https://git.lix.systems/lix-project/lix/issues/452
    lix.url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    lix.flake = false;
    # lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.inputs.lix.follows = "lix";

    # secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      lix-module,
      flake-utils,
      nixos-hardware,
      sops-nix,
      ...
    }:
    {
      nixosConfigurations = {
        pi-lix = nixpkgs.lib.nixosSystem {
          modules = [
            # use lix as default
            lix-module.nixosModules.default
            nixos-hardware.nixosModules.raspberry-pi-4
            # allow building sd card images
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            sops-nix.nixosModules.sops
            ./configuration.nix
          ];
          specialArgs = {
            inherit inputs;
          };
        };

        pi-nix = nixpkgs.lib.nixosSystem {
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            # allow building sd card images
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            sops-nix.nixosModules.sops
            ./configuration.nix
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
    }
    // flake-utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "fnord";
      shell = ./shell.nix;
    };
  # See https://git.berlin.ccc.de/cccb/ringbahn/src/branch/main/pkgs/reencrypt-secrets.nix
  # for how to extend these definitions with custom packages or dev shells
}
