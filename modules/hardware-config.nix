{ pkgs, inputs, ... }:
let
  # workaround for error with missing packages, not sure if still required when building in docker
  # like this:
  # modprobe: FATAL: Module sun4i-drm not found in directory /nix/store/g1hq1b9s38z559v53xgn5imy7fspqx7m-linux-rpi-6.6.51-stable_20241008-modul>
  overlay = final: super: {
    makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
  };
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  nixpkgs.overlays = [ overlay ];
  nixpkgs.hostPlatform = "aarch64-linux";

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  services.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
    # need these for raspi firmware updates. See docs/firmware-update.md
    libraspberrypi
    raspberrypi-eeprom
  ];
}
