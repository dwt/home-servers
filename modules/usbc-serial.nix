{
  # TODO tell uboot to also use the usb serial device
  # so I can go back to an old nixos revision
  hardware.raspberry-pi."4".dwc2.enable = true;
  # enable serial device over usb-c
  boot.initrd.kernelModules = [
    "g_serial"
  ];
  # show boot output on serial console to help debugging
  boot.kernelParams = [
    "console=ttyGS0,115200n8"
  ];
  # allow login via serial console
  # only waits for around around 60s for logins
  systemd.services."serial-getty@ttyGS0" = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
  };
}
