# How to bring up a new pi

1. Add a new directory in `hosts/$HOSTNAME/` for the new pi.
1. Add a new entry in `flake.nix` for the new pi.
1. Setup sops to support the new pi as far as it goes

Provisioning the new pi should now work, but it won't join any wireless, because it cannot decrypt the wireless keys, because it has just generated a new host ssh key - which is the trust anchor for all the crypto. To fix this:

1. Connect to the new pi via ethernet
1. Enable internet connecition sharing
1. Monitor ARP for the new pi to show up `arp -ni bridge100 -la` or `bin/raspi-ip`. This took me a few minutes to show up.
1. Login via bin/insecure-ssh $IP

Either deploy the currently saved private key to the raspi
1. Deploy via `bin/ssh-deploy-host-key $HOST $IP` to the new pi, so it can decrypt the secrets

or adapt to the new key it generated:
1. Copy down the ssh keys and add generate a new age key from them and reencrypt the secrets to that thing (see [sops.md](sops.md))
1. Add key for ip to local config so `bin/switch $HOST $IP` works.
  1. `ssh-keygen -R $IP`
  1. `ssh-keyscan $IP >>~/.ssh/known_hosts`
1. Deploy via insecure-ssh to the new pi, so it can decrypt the secrets
