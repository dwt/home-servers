# Design

- btrfs weil es nahezu die gleichen features hat wie zfs, aber viel weniger ram verbraucht (zfs für 8TB ~ 4-8GB ram)
- Insbesondere checksummen, ich kriege also bitflips mit!

## Setup

```sh
umount /mnt/backup
wipefs -a /dev/sda2
mkfs.btrfs -L backup /dev/sda2
mount /dev/sda2 /mnt
btrfs subvolume create /mnt/timemachine
umount /mnt
```

Geplante mount-optionen

```
compress=zstd # time machine backups haben viele null bytes, und zstd ist schnell auf der kleinen cpu
autodefrag # time machine schreibt gerne 16KB blöcke, und fragmentiert damit das FS
noatime # etwas weniger meta data writes -> speed
space_cache=v2 # schnellere mounts von großen platten
```

kein automatisches discard, fstrim.timer übernimmt das freigeben von gelöschten blocks by default auf NixOS.
