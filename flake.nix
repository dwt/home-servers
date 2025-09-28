{
  description = "Häckers NixOS Homeserver configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # add packages from this if needed
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # raspberry pi hardware description
    nixos-hardware.url = "github:NixOS/nixos-hardware";
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
      ...
    }:
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

      darwinSystems = nixpkgs.lib.filter (nixpkgs.lib.hasSuffix "-darwin") nixpkgs.lib.systems.flakeExposed;
      forAllSystems = nixpkgs.lib.genAttrs darwinSystems;
      forAllSystemsWithPackages =
        fn:
        forAllSystems (
          system:
          fn {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
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
        nixpkgs.lib.nixosSystem {
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
            hosts/pi/configuration.nix
          ];
        };

        pi-test = nixosSystem {
          modules = [
            hosts/pi-test/configuration.nix
          ];
        };
      };

      devShells = forAllSystemsWithPackages (
        { pkgs, ... }:
        {
          default = import ./shell.nix { inherit pkgs; };
        }
      );
    };
  # See https://git.berlin.ccc.de/cccb/ringbahn/src/branch/main/pkgs/reencrypt-secrets.nix
  # for how to extend these definitions with custom packages or dev shells
}
