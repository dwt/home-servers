# How SOPS works

- [sops Documentation](https://github.com/getsops/sops?tab=readme-ov-file#encrypting-using-age)

- [sops-nix Documentation](https://github.com/Mic92/sops-nix?tab=readme-ov-file#sops-nix)

- `.sops.yaml` contains
  - at least one age key derived from a private ssh key of me to en- and decrypt secrets
  - `bin/convert-ssh-to-age-key` to create and store it in `~/.config/sops/age/keys.txt`
  - `cat path/to/ed25519.pub | nix run nixpkgs#ssh-to-age` to convert a single public key
  - at one age key generated from every host that these secrets need to be deployed to
  - rules that map these keys to secrets files

- `secrets.yaml` contains the secrets (should be split up by host in the future)
  - `sops secrets.yaml` to edit them
  - `sops updatekeys **/secrets.yaml` to reencrypt the file after keys change

- ssh host keys:
  - On the target system, the ssh host key is the trust anchor which decrypts all secrets and makes them available in `/run/secrets/*`, possibly symlinked from other places in the system after boot
  - Since I cannot (yet) deploy ssh host keys when creating an sd-image.
  - `bin/ssh-deploy-host-key` to deploy the host key to the target system and overwrite the generated one

- `git config --global  diff.sopsdiffer.textconv "sh -c 'sops -d $1 2>/dev/null || cat $1' --"`
  to get `git diff -p` to show decrypted secrets

# TODO Better ways to deploy my raspberry pi secrets

Modify the way the binary sd-image is built, so it includes the hostkey already.

- That would be a long term solution, but requires more investigation how image building works.
- [Reading how it is created is probably a good first step](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/sd-card/sd-image.nix)

BUT: I do not see how this would not put the secret into my local nix store, which is a no no
