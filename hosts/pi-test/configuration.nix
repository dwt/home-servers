{
  networking.hostName = "pi-test";

  my.raspberry-pi.usbc-serial.enable = true;

  # Just a marker what the first installed version was
  # Ensures database files are kept backwards compatible with data from this version
  system.stateVersion = "24.11";
}
