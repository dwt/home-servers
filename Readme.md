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

## Pi Recovery

### LAN

If the pi can't get into the wireless network, try ethernet as backup. Most likely a problem with secret deployment. Symptoms: Can't get on wifi, can't login on console

SSH login via ethernet should still work, as public key authentication is not affected by missing secrets.

- Mac Internet Conneciton Sharing -> USB-C Ethernet Adapter -> Ethernet -> Pi
- `bin/raspi-ip` will find the IP after some time
- `bin/insecure-ssh` to login

### External Screen

Pop on an external display and keyboard and see what's up. Cumbersome, but quite reliable to debug boot problems. I'm currently missing an adapter for micro HDMI to HDMI, so can't do this with the Labists Case.

## Pi Case Manuals

- [Argon One V2 Case Manual](https://cdn.shopify.com/s/files/1/0556/1660/2177/files/AR1_M.2_INSTRUCTION_MANUAL_20200922.pdf?v=1646125952), [Backup Argon ONE Scripts](https://github.com/okunze/Argon40-ArgonOne-Script?tab=readme-ov-file)
  - Press off switch 3 seconds for soft shutdown
  - Press off switch 5 seconds for hard shutdown
- [Labists Black Case for Raspberry Pi 4 Model B](https://labists.com/products/raspberry-pi-4-case-kit)

## Open Questions

- [ ] Tease apart config for the raspi at home and in car
- [ ] What about auto updates?
- [ ] How do I get my local machine to build for the raspi to speed up deployments?
- [ ] How describe disk partitions in nix?
- [ ] What is the state of the metal enclosed pi 4? How do I get it to nixos?
