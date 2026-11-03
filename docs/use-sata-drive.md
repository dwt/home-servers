# How to move the nixos install to the sata drive

Only applicable to the Argon One case with sata drive.

TODO how did I move the nix install over to that drive?

- Copy over memory card to sata drive
  - `dd if=/dev/mmcblk0 of=/dev/sda bs=1M status=progress`
  - perhaps better command wold be: `dd if=/dev/mmcblk0 of=/dev/sda bs=4M iflag=fullblock oflag=direct conv=fsync status=progress`
  - leaves all UUIDs duplicated - but fixing that breaks the boot.
  - nachdem ich das system noch mal aktualisiert, und noch mal mit `dd` die sd card auf die platte koppiert hab, geht jetzt scheinbar wieder alles. WTF?
  - TODO: das filesystem muss noch resized werden

## Boot from sata / usb

```sh
$ sudo -E rpi-eeprom-config --edit
```

Current setting on the pi:

```ini
[all]
BOOT_ORDER=0xf14
```

For a Raspberry Pi 4, `0xf14` means: try USB mass storage first, then SD, then
restart the boot sequence.

After editing, save and close the editor, then reboot:

```sh
$ sudo reboot
```

To verify the configured boot order afterwards:

```sh
$ rpi-eeprom-config
```

This is currently configured manually in the EEPROM bootloader config on the
device and is not managed declaratively from this repo yet.

## First checks for the next debugging session

Before changing UUIDs or bootloader settings again, collect the current state.
This should make it easier to tell whether the problem is EEPROM config,
USB/SATA enumeration, or the disk layout itself.

```sh
# bootloader version currently installed
vcgencmd bootloader_version

# effective EEPROM config
sudo rpi-eeprom-config

# kernel view of the attached drives and filesystems
lsblk -o NAME,PATH,SIZE,FSTYPE,LABEL,UUID,PARTUUID,MOUNTPOINTS
blkid

# confirm what was actually mounted for / and /boot
findmnt /
findmnt /boot

# keep a copy of the current partition tables
sudo fdisk -l /dev/mmcblk0
sudo fdisk -l /dev/sda
```

If the Pi still prefers SD over SATA/USB even with `BOOT_ORDER=0xf14`, also
capture bootloader logs:

```ini
[all]
BOOT_ORDER=0xf14
BOOT_UART=1
```

Then connect serial or otherwise capture the boot log and check whether USB-MSD
was actually attempted first.

Useful things to note explicitly next time:

- exact Pi model and board revision
- exact bootloader release date from `vcgencmd bootloader_version`
- whether the SD card is a normal Raspberry Pi / NixOS boot card or just has a
  leftover / partial partition table
- whether the SATA drive is connected directly, through the Argon One bridge,
  or through an extra hub
- whether the same SATA device behaves differently on USB2 vs USB3

## Relevant upstream issues

- `rpi-eeprom#423`: `BOOT_ORDER=0xf14` can still fail when an SD card is
  present if that SD card contains only an empty DOS partition table or a lone
  Linux partition. Maintainer comment says this is a ROM limitation: the ROM
  sees the SD card first and can hang before normal boot order fallback works.
  Practical implication: if reproducing this again, test with no SD inserted
  and with a known-good full bootable SD card, not a half-initialized one.
- `rpi-eeprom#454`: changing `BOOT_ORDER` inside `[tryboot]` is not supported.
  The report used bootloader release `2022/11/25`. Practical implication: do
  not assume `[tryboot]` can temporarily switch SD-first and USB-first boot.
- `rpi-eeprom#466`: looked at first like `BOOT_ORDER` was ignored, but the
  maintainer's reading of the logs was that USB boot was attempted and then
  timed out (`USB MSD stopped. Timeout: 25 seconds`). Practical implication:
  distinguish "SD was chosen first" from "USB was tried first but the bridge or
  drive did not respond in time".

## Notes for this machine

- Current manual EEPROM setting on the Pi is `BOOT_ORDER=0xf14`.
- That means: try USB mass storage first, then SD, then restart the boot
  sequence.
- This used to work and may have stopped working around the November 2022
  firmware / bootloader changes. The closest upstream match found so far is the
  `[tryboot]` report in `rpi-eeprom#454`, but that does not fully explain a
  normal non-`tryboot` failure.
- If this fails again, first verify whether the SD card contents match the ROM
  limitation described in `rpi-eeprom#423` before changing UUIDs or repartitioning.

https://github.com/raspberrypi/rpi-eeprom/issues/792

describes reason why externel booting might fail, check if that is the case for me and add a fix to nixpkgs if it is.
