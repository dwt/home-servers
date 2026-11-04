{ config, ... }: {
  system.stateVersion = "26.11";
  imports = [ ../../modules/hardware/raspi5.nix ];

  sops.secrets.inga_password_hash.sopsFile = ./secrets.yaml;
  sops.secrets.inga_password_hash.neededForUsers = true;
  users = {
    mutableUsers = false;
    users."inga" = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.inga_password_hash.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAnYQUwCjkRJ6PggrWe/yzqF0m1RD1bBr/yXRPWFJ6/X Raspberry pi"
      ];
      extraGroups = [
        "wheel" # Allow ‘sudo’ for this user.
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  networking.wireless = {
    networks = {
      # wireless password secrets need to be configured in global secrets.yaml
      # because only one secrets file can be generated for wireless config
      "Muehl8".pskRaw = "ext:muehl8_psk";
    };
  };

}
