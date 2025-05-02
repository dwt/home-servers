{
  sdImage.populateFirmwareCommands = ''
    mkdir -p firmware/extlinux
    # echo "console=ttyS0,115200n8" > firmware/extlinux/extlinux.conf
    # echo "console=ttyGS0,115200n8" > firmware/extlinux/extlinux.conf
    chmod +w firmware/config.txt
    echo "dtoverlay=dwc2" >> firmware/config.txt
  '';
  boot = {
    initrd.kernelModules = [
      "vc4"
      "bcm2835_dma"
      "i2c_bcm2835"
    ];
    kernelParams = [
      # "console=ttyS1,115200n8"
      # "console=ttyGS0,115200n8"
      "console=ttyGS0,115200"
      #"console=serial0,115200"
      "modules-load=dwc2,g_serial"
    ];
  };
}
