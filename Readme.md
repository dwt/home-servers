# System configuration for my raspberry pi 4 models

When building on darwin, this requires a linux builder. I use [cpick/rosetta-builder](https://github.com/cpick/nix-rosetta-builder).

## Build an sd card image

`bin/build-sd-image.sh`

## Flash the image to the sd card

check the disk
`diskutil list external physical`

note the disk name of the sd card
`set --local disk "/dev/disk4"`

ensure it is umounted
`diskutil unmountDisk $disk`

Write the image to the sd card
`pv nixos-sd.img | sudo dd of=$disk bs=128K`

eject the disk
`diskutil eject $disk`

and use it to boot the raspberry pi

## Remote deployments

`bin/config-test.sh` or `bin/config-switch.sh`

## Diff changes

This snippet shows the changes in the system that would be made compared to the currently deployed version

`bin/config-diff.sh`

# Find Pi on Network

`bin/raspi-ip`

# Pi Case Manuals

- [Argon One V2 Case Manual](https://cdn.shopify.com/s/files/1/0556/1660/2177/files/AR1_M.2_INSTRUCTION_MANUAL_20200922.pdf?v=1646125952), [Backup Argon ONE Scripts](https://github.com/okunze/Argon40-ArgonOne-Script?tab=readme-ov-file)
- [Labists Black Case for Raspberry Pi 4 Model B](https://labists.com/products/raspberry-pi-4-case-kit)

## Open Questions

- [ ] What about auto updates?
- [ ] How describe disk partitions in nix?
- [ ] What is the state of the metal enclosed pi 4? How do I get it to nixos?
