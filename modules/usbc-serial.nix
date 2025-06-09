{ lib, config, ... }:
{
  # TODO tell uboot to also use the usb serial device
  # so I can go back to an old nixos revision
  # Not sure this is actually possible though
  # This says it's not: https://stackoverflow.com/questions/63104542/can-usb-otg-be-used-for-u-boot-and-linux-consoles

  # Deeper documentation
  # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/dwc2.nix
  # https://linux-sunxi.org/USB_Gadget/Serial
  # https://www.kernel.org/doc/Documentation/usb/gadget-testing.txt
  options = {
    my.raspberry-pi.usbc-serial.enable = lib.mkEnableOption "Enable USB-C serial console";
  };

  config = lib.mkIf config.my.raspberry-pi.usbc-serial.enable {
    # enable the device overlay so usb c is initialized
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
    # can be restarted with `systemctl start serial-getty@ttyGS0.service`
    systemd.services."serial-getty@ttyGS0" = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
    };
  };
}
