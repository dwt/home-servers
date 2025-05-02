{ inputs, ... }:
{
  imports = [
    # allow building sd card images
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  # compressed image is just harder to flash and take longer to build
  sdImage.compressImage = false;
}
