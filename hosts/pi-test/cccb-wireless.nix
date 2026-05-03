{ config, ... }:
{
  # define secret
  sops.secrets."wireless.secrets.cccb" = { };
  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets."wireless.secrets.cccb".path;
    networks = {
      # SSID can come from secret too, perhaps marked as *_unencrypted
      # not easily, as there is no secret access with sops in the evaluation of this file
      "Geekz.Karibik".pskRaw = "ext:cccb_psk";
    };
  };
}
