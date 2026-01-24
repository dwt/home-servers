{
  description = "Häckers NixOS Homeserver configurations";

  inputs = {
    # main package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # only as needed
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # raspberry pi hardware description
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-automation.url = "github:dwt/home-automation";
    home-automation.inputs.nixpkgs.follows = "nixpkgs";
    # tooling
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    let
      # Could this be upstreamed?
      # perhaps with a generator to get all functions by handing in the packages in question?
      # forFlakeExposedSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      # forFlakeExposedSystemsWithPackages =
      #   fn:
      #   forFlakeExposedSystems (
      #     system:
      #     fn {
      #       inherit system;
      #       pkgs = nixpkgs.legacyPackages.${system};
      #     }
      #   );

      darwinSystems = inputs.nixpkgs.lib.filter (inputs.nixpkgs.lib.hasSuffix "-darwin") inputs.nixpkgs.lib.systems.flakeExposed;
      forAllSystems = inputs.nixpkgs.lib.genAttrs darwinSystems;
      forAllSystemsWithPackages =
        fn:
        forAllSystems (
          system:
          fn {
            inherit system;
            pkgs = inputs.nixpkgs.legacyPackages.${system};
          }
        );

      commonModules = [
        modules/sops.nix
        modules/locale.nix
        modules/hardware-config.nix
        modules/standard-packages.nix
        modules/nix-setup.nix
        modules/remote-access.nix
        modules/user.nix
        modules/sd-image.nix
        modules/usbc-serial.nix
      ];
      nixosSystem =
        { modules }:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = commonModules ++ modules;
        };
    in
    {
      nixosConfigurations = {
        pi = nixosSystem {
          modules = [
            hosts/pi/home-automation.nix
            hosts/pi/time-machine.nix
            hosts/pi/configuration.nix
          ];
        };

        pi-test = nixosSystem {
          modules = [
            hosts/pi-test/configuration.nix
          ];
        };
      };

      # Run the hooks in a sandbox with `nix flake check`.
      # Read-only filesystem and no internet access.
      checks = forAllSystemsWithPackages (
        { system, ... }:
        {
          pre-commit-check = inputs.git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              deadnix.enable = true;
              flake-checker.enable = true;
            };
          };
        }
      );

      devShells = forAllSystemsWithPackages (
        { system, pkgs, ... }:
        {
          default = import ./shell.nix { inherit system inputs pkgs; };
        }
      );
    };
  # See https://git.berlin.ccc.de/cccb/ringbahn/src/branch/main/pkgs/reencrypt-secrets.nix
  # for how to extend these definitions with custom packages or dev shells
}
