# System configuration for my raspberry pi 4 models

When building on darwin, this requires a linux builder. I use [cpick/rosetta-builder](https://github.com/cpick/nix-rosetta-builder).

## Some Scripts:

- `bin/build-image` - Build an image for the raspberry pi
- `bin/flash-image` - Flash the image to the sd card
- `bin/test` - Switch to the configuration for testing (i.e. auto revert after reboot)
- `bin/switch` - Switch to the configuration permanently
- `bin/diff` - Show the changes that would be made to the system
- `bin/update` - Update all flake dependencies
- `bin/raspi-ip` - Find the ip of the raspberry pi on the network

## Pi Recovery

### LAN

If the pi can't get into the wireless network, try ethernet as backup. Most likely a problem with secret deployment. Symptoms: Can't get on wifi, can't login on console

SSH login via ethernet should still work, as public key authentication is not affected by missing secrets.

- Mac Internet Conneciton Sharing -> USB-C Ethernet Adapter -> Ethernet -> Pi
- `bin/raspi-ip` will find the IP after some time
- `bin/insecure-ssh` to login

### External Screen

Pop on an external display and keyboard and see what's up. Cumbersome, but quite reliable to debug boot problems.

## Pi Case Manuals

- [Argon One V2 Case Manual](https://cdn.shopify.com/s/files/1/0556/1660/2177/files/AR1_M.2_INSTRUCTION_MANUAL_20200922.pdf?v=1646125952), [Backup Argon ONE Scripts](https://github.com/okunze/Argon40-ArgonOne-Script?tab=readme-ov-file)
  - Press off switch 3 seconds for soft shutdown
  - Press off switch 5 seconds for hard shutdown
- [Labists Black Case for Raspberry Pi 4 Model B](https://labists.com/products/raspberry-pi-4-case-kit)

## TODO

- [ ] What about auto updates?
  - otherwise the repo would need checking out on the host and then could update via [`system.autoupgrade`](https://nixos.wiki/wiki/Automatic_system_upgrades) - but requires a checkout on the host with all key material
  - also, some times packages on nixpkgs are broken, and not cached, basically I don't want to update when there are uncached packages on nixpkgs. How do I do that?
  - [`system.autoUpgrade.flags` can contain `[ "--update-input" "nixpkgs" "--commit-lock-file" ]` even without `--commit-lock-file` to stay up to date for flake based systems](https://search.nixos.org/options?channel=25.05&show=system.autoUpgrade.flags&from=0&size=50&sort=relevance&type=packages&query=flake). [Used together with `system.autoUpgrade.flake`](https://search.nixos.org/options?channel=25.05&show=system.autoUpgrade.flake&from=0&size=50&sort=relevance&type=packages&query=system.)
- [ ] move to boot to the ssd
  - [ ] How to describe disk partitions in nix? [Disco](https://github.com/nix-community/disko)
- [ ] How to get contact syncing to work via the pi
