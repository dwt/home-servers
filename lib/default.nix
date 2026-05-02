{ pkgs }:
{
  # TODO contribute mkPkgs to nixpkgs.lib
  # REFACt move function into lib file
  mkPkgs =
    customNixpkgsVersion:
    import customNixpkgsVersion {
      inherit (pkgs) config;
      inherit (pkgs.stdenv.hostPlatform) system;
    };
}
