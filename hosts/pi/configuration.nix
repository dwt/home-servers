{ pkgs, ... }:
{
  networking.hostName = "pi";

  # Enable Argon One fan control
  services.hardware.argonone.enable = true;

  # might need this to login to debug
  # console.enable = false;

  # Just a marker what the first installed version was
  # Ensures database files are kept backwards compatible with data from this version
  system.stateVersion = "24.11";
}
