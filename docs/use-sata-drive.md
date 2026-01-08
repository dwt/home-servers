# How to move the nixos install to the sata drive

Only applicable to the Argon One case with sata drive.

TODO how did I move the nix install over to that drive?

- Copy over memory card to sata drive
  - `dd if=/dev/mmcblk0 of=/dev/sda bs=1M status=progress`
  - leaves all UUIDs duplicated - but fixing that breaks the boot.

## Fix UUIDs - but note: breaks boot
- made all the UUIDS unique
  - ext4:
    - `e2fsck -f /dev/sda2` # needs check first
    - `tune2fs -U $(cat /proc/sys/kernel/random/uuid) /dev/sda2`
  - vfat:
    - `mlabel -i /dev/sda1 -n` # set new uuid
    - `dosfslabel /dev/sda1 FIRMWARE` # repair label

PARTUUID ist schwierig, MBR disks kann man über fdisk ändern, aber nur imperativ?

```sh
[root@pi:~]# fdisk   /dev/sda

Willkommen bei fdisk (util-linux 2.41.2).
Änderungen werden vorerst nur im Speicher vorgenommen, bis Sie sich
entscheiden, sie zu schreiben.
Seien Sie vorsichtig, bevor Sie den Schreibbefehl anwenden.


Befehl (m für Hilfe): x

Expertenbefehl (m für Hilfe): i

Einen neuen Festplattenbezeichner eingeben: 0x2178694f

Festplattenbezeichner ist von 0x2178694e nach 0x2178694f geändert worden.

Expertenbefehl (m für Hilfe): r

Befehl (m für Hilfe): w
Die Partitionstabelle wurde verändert.
ioctl() wird aufgerufen, um die Partitionstabelle neu einzulesen.
Festplatten werden synchronisiert.
```

Nächster Schritt: Bootreihenfolge ändern.

```sh
$ mkdir -p /boot/firmware
$ mount /dev/disk/by-label/FIRMWARE /boot/firmware
$ rpi-eeprom-config --edit
# add
