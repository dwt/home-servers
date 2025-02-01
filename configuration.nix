# TODO
# - setup fan control (which will be different on the argon one)
{ config, pkgs, ... }:
let
  # Why is this needed, what exactly does this work around?
  overlay = final: super: {
    makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
  };
in
{
  sops.defaultSopsFile = ./secrets.yaml;

  # compressed image is just harder to flash
  sdImage.compressImage = false;

  # what nixos version to use
  # system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable-small";

  # workaround for error with missing packages, not sure if still required when building in docker
  nixpkgs.overlays = [ overlay ];
  nixpkgs.hostPlatform = "aarch64-linux";

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  services.pulseaudio.enable = true;

  # Enable flakes and new 'nix' command
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Opinionated: disable global registry
  # nix.settings.flake-registry = "";
  # Workaround for https://github.com/NixOS/nix/issues/9574
  nix.settings.nix-path = config.nix.nixPath;
  # Opinionated: disable channels
  nix.channel.enable = false;

  networking.hostName = "pi";

  # make pi.local work
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish.enable = true;
    publish.workstation = true;
  };

  # TODO samba setup
  # see https://nixos.wiki/wiki/Samba

  sops.secrets."wireless.secrets" = { };
  networking.wireless.secretsFile = config.sops.secrets."wireless.secrets".path;
  networking.wireless.enable = true;
  networking.wireless.networks = {
    "ext:home_ssid" = {
      pskRaw = "ext:home_psk";
    };
  };

  services.openssh = {
    enable = true;
    # use keys only.
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF8";

  sops.secrets.dwt_password_hash.neededForUsers = true;
  users = {
    mutableUsers = false;
    users."dwt" = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.dwt_password_hash.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJpixTba/bWGGVDM45r98YLID0t2R75U/7jL1Jblgatd dwt@seneca.local"
      ];
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
      ];
    };
  };

  # Don't want to enter a password every time for sudo
  security.sudo.wheelNeedsPassword = false;

  # might need this to login to debug
  # console.enable = false;

  environment.systemPackages = with pkgs; [
    # not quite sure why these are needed
    libraspberrypi
    raspberrypi-eeprom

    # my dependencies
    rmate-sh
    glances
  ];

  # Just a marker what the first installed version was
  # Ensures database files are kept backwards compatible with data from this version
  system.stateVersion = "24.11";
}
