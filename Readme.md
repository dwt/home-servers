# System configuration for my raspberry pi 4 models

When building on darwin, this requires a linux builder. I use [cpick/rosetta-builder](https://github.com/cpick/nix-rosetta-builder).

## Scripts:

- `bin/build-image` - Build an image for the raspberry pi
- `bin/flash-image` - Flash the image to the sd card
- `bin/test` - Switch to the test configuration (i.e. auto revert after reboot)
- `bin/switch` - Switch to the production configuration
- `bin/diff` - Show the changes that would be made to the system
- `bin/update` - Update the flake dependencies
- `bin/raspi-ip` - Find the ip of the raspberry pi on the network

## Pi Case Manuals

- [Argon One V2 Case Manual](https://cdn.shopify.com/s/files/1/0556/1660/2177/files/AR1_M.2_INSTRUCTION_MANUAL_20200922.pdf?v=1646125952), [Backup Argon ONE Scripts](https://github.com/okunze/Argon40-ArgonOne-Script?tab=readme-ov-file)
  - Press off switch 3 seconds for soft shutdown
  - Press off switch 5 seconds for hard shutdown
- [Labists Black Case for Raspberry Pi 4 Model B](https://labists.com/products/raspberry-pi-4-case-kit)

## Open Questions

- [ ] What about auto updates?
- [ ] How describe disk partitions in nix?
- [ ] What is the state of the metal enclosed pi 4? How do I get it to nixos?
