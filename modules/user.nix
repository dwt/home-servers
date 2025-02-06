{ config, ... }:
{
  sops.secrets.dwt_password_hash.neededForUsers = true;
  users = {
    mutableUsers = false;
    users."dwt" = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.dwt_password_hash.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJpixTba/bWGGVDM45r98YLID0t2R75U/7jL1Jblgatd dwt@seneca.local"
      ];
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
      ];
    };
  };

  # Don't want to enter a password every time for sudo
  security.sudo.wheelNeedsPassword = false;
}
