{ config, ... }: {
  # Just a marker what the first installed version was
  # Ensures database files are kept backwards compatible with data from this version
  system.stateVersion = "26.11";

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
}
