{
  networking.hostName = "pi";

  # kills booting on 25.05 for me -> Explore on pi-test first
  my.raspberry-pi.usbc-serial.enable = false;

  # Enable Argon One fan control
  services.hardware.argonone.enable = true;

  # Just a marker what the first installed version was
  # Ensures database files are kept backwards compatible with data from this version
  system.stateVersion = "24.11";
}
