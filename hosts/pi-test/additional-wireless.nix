{
  networking.wireless = {
    networks = {
      # secrets need to be configured in global secrets.yaml, because only one secrets file can be generated for wireless config
      "Geekz.Karibik".pskRaw = "ext:cccb_psk";
      "Muehl8".pskRaw = "ext:muehl8_psk";
    };
  };
}
