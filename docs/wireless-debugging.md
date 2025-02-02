# Wireless Network Debugging

- `iwconfig` - show wireless network interface configuration
- `iwlist scan | grep ESSID` - show available networks
- `wpa_supplicant -B -i wlan0 -c <(wpa_passphrase 'SSID' 'passphrase') &` - connect to a network
