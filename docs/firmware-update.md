# How to update Raspi Firmware

[nix.dev has some docs](https://nix.dev/tutorials/nixos/installing-nixos-on-a-raspberry-pi.html#updating-firmware)

```shell
nix-shell -p raspberrypi-eeprom
mount /dev/disk/by-label/FIRMWARE /mnt
BOOTFS=/mnt FIRMWARE_RELEASE_STATUS=stable rpi-eeprom-update -d -a
```
