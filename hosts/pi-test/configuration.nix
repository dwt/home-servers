{
  networking.hostName = "pi-test";

  # kills booting on 25.05 for me -> Explore on pi-test first
  my.raspberry-pi.usbc-serial.enable = false;

  # Just a marker what the first installed version was
  # Ensures database files are kept backwards compatible with data from this version
  system.stateVersion = "24.11";
}
