{ config, pkgs, ... }:
{
  # define secret
  sops.secrets."wireless.secrets" = {
    group = "wpa_supplicant"; # TODO replace with reference to configured group of wpa-supplicant systemd unit?
    mode = "0440";
  };
  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets."wireless.secrets".path;
    networks = {
      # SSID can come from secret too, perhaps marked as *_unencrypted
      # not easily, as there is no secret access with sops in the evaluation of this file
      "Wo bleibt die Devolution?".pskRaw = "ext:home_psk";
    };
  };

  # for manual wireless management
  environment.systemPackages = [
    pkgs.iw
  ];

  # allow usage of `wpa_cli`
  # networking.wireless.userControlled.enable = true;

  # the host key is the root of all trust in sops, so I need to write it from sops
  # That however is not easy, as it needs the host-key to decrypt itself.
  # Later on I plan to bake this into the sd-image - until then it's a manual process with
  # `bin/ssh-deploy-host-key`
  services.openssh = {
    enable = true;
    # use keys auth only
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  # make $host.local work
  services.avahi = {
    enable = true;
    nssmdns4 = true; # support .local domains
    settings.publish = {
      disable-publishing = false; # default: just listening
      publish-workstation = true; # advertises this machine as 'workstation'
    };
  };

}
