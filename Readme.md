# System configuration for my raspberry pi 4 models

## Build an sd card image

`docker compose run --rm nix`

to do this manually, try

`docker compose run --rm nix bash`

and invoke the build steps manually.

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
