{ config, pkgs, ... }:
let
  # Why is this needed, what exactly does this work around?
  overlay = final: super: {
    makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
  };
in
{
  # workaround for error with missing packages, not sure if still required when building in docker
  # like this:
  # modprobe: FATAL: Module sun4i-drm not found in directory /nix/store/g1hq1b9s38z559v53xgn5imy7fspqx7m-linux-rpi-6.6.51-stable_20241008-modul>
  nixpkgs.overlays = [ overlay ];
  nixpkgs.hostPlatform = "aarch64-linux";

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  # hardware.pulseaudio.enable = true;
  services.pulseaudio.enable = true;

  # Enable Argon One fan control
  services.hardware.argonone.enable = true;

  environment.systemPackages = with pkgs; [
    # need these for raspi firmware updates. See docs/firmware-update.md
    libraspberrypi
    raspberrypi-eeprom
  ];
}
