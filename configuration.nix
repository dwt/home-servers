{ pkgs, ... }:
{
  imports = [
    ./modules/hardware-config.nix
    ./modules/nix-setup.nix
    ./modules/remote-access.nix
    ./modules/user.nix
    ./modules/home-automation.nix
  ];

  sops.defaultSopsFile = ./secrets.yaml;

  # compressed image is just harder to flash and take longer to build
  sdImage.compressImage = false;

  # TODO how do I get auto updates?
  # system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable-small";

  networking.hostName = "pi";

  # TODO samba setup
  # see https://nixos.wiki/wiki/Samba

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF8";

  # might need this to login to debug
  # console.enable = false;

  environment.systemPackages = with pkgs; [
    # nix debugging
    nix-tree

    # my dependencies
    rmate-sh
    glances
  ];

  # Just a marker what the first installed version was
  # Ensures database files are kept backwards compatible with data from this version
  system.stateVersion = "24.11";
}
