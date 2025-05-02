{
  description = "Häckers NixOS Homeserver configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # add packages from this if needed
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # raspberry pi hardware description
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    # secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-automation.url = "github:dwt/home-automation";
    home-automation.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      lix-module,
      flake-utils,
      nixos-hardware,
      sops-nix,
      home-automation,
      ...
    }:
    {
      nixosConfigurations = {
        pi = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            modules/sops.nix
            modules/locale.nix
            modules/hardware-config.nix
            modules/standard-packages.nix
            modules/nix-setup.nix
            modules/remote-access.nix
            modules/user.nix
            modules/sd-image.nix

            hosts/pi/home-automation.nix
            hosts/pi/configuration.nix
          ];
        };
      };
    }
    // flake-utils.lib.simpleFlake {
      name = "pi";
      inherit self nixpkgs;
      shell = ./shell.nix;
    };
  # See https://git.berlin.ccc.de/cccb/ringbahn/src/branch/main/pkgs/reencrypt-secrets.nix
  # for how to extend these definitions with custom packages or dev shells
}
