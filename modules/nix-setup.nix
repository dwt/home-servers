{
  config,
  inputs,
  pkgs,
  ...
}:
{
  # Enable flakes and new 'nix' command
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Opinionated: disable global registry
    # nix.settings.flake-registry = "";
    # Workaround for https://github.com/NixOS/nix/issues/9574
    nix-path = config.nix.nixPath;
    trusted-users = [
      config.users.users.dwt.name
    ];
  };
  # Opinionated: disable channels
  nix.channel.enable = false;

  # automatically prune no longer needed nix packages
  # nix.gc.automatic = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 10";
  };

  # provide my custom nixpkgs versions as optional module args
  _module.args =
    let
      # TODO contribute mkPkgs to nixpkgs.lib
      mkPkgs =
        customNixpkgsVersion:
        import customNixpkgsVersion {
          inherit (config.nixpkgs) config;
          inherit (pkgs.stdenv.hostPlatform) system;
        };
    in
    {
      # for the packages that are yet not part of the stable distribution
      pkgs-unstable = mkPkgs inputs.nixpkgs-unstable;
      # for when I am working on a package and want to test / use it after it was merged, but not yet to unstable
      # usually requires compilation, possibly of many dependencies!
      # I don't want to make this too easy, which is why the input is commented out too
      # pkgs-master = mkPkgs inputs.nixpkgs-master;
      # pkgs-local = mkPkgs inputs.nixpkgs-local;
    };

  # setup lix
  # https://lix.systems/add-to-config/#advanced-change
  # see there for advanced nix -> lix overrides of custom packages
  # also supports: stable, latest, git
  nix.package = pkgs.lixPackageSets.latest.lix;

}
