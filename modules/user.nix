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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgnOPFv54EK6/fxb49JxiNaD5C5qBdKs2dCANFvyxTC Terminus@iPad"
      ];
      extraGroups = [
        "wheel" # Allow ‘sudo’ for this user.
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
