# Enable my custom tradfri <-> homekit bridge
{ config, ... }:
{
  sops.secrets."tradfri_bridge.state" = {
    owner = "home-automation";
    path = config.services.home-automation.homekit.secretsFile;
  };
  sops.secrets."tradfri.conf" = {
    owner = "home-automation";
    path = config.services.home-automation.tradfri.secretsFile;
  };
  services.home-automation = {
    enable = true;
  };
}
