{ config, pkgs, ... }:
{
  fileSystems."/mnt/backup" = {
    label = "backup";
    fsType = "btrfs";
    options = [
      "subvol=timemachine"
      "compress=zstd"
      "autodefrag" # tm writes 16KB chunks, which would greatly fragment the disk.
      "noatime" # less metadata writes, slightly faster and not needed for backup volume
    ];
  };

  # check monthly if bits flipped
  services.btrfs.autoScrub.enable = true;

  services.samba = {
    enable = true;
    openFirewall = true;
    settings.TimeMachine = {
      path = "/mnt/backup";
      "vfs objects" = "catia fruit streams_xattr";
      "valid users" = "dwt vera"; # TODO also allow vera
      "public" = "no";
      "writeable" = "yes";
      "fruit:aapl" = "yes";
      "fruit:time machine" = "yes";
    };
  };

  # can only set smb password if the unix user is available
  sops.secrets.vera_password_hash.neededForUsers = true;
  users.users."vera" = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.vera_password_hash.path;
  };

  # create samba user with password from sops secret
  # requires these users to be available on the system
  sops.secrets.dwt_password_plain.neededForUsers = true;
  sops.secrets.vera_password_plain.neededForUsers = true;
  system.activationScripts = {
    init_timemachine_smbpasswd.text = ''
      function create_smb_user {
        local username="$1"
        local password_path="$2"
        local password="$(cat "$password_path")"

        printf "$password\n$password\n" | ${config.services.samba.package}/bin/smbpasswd -sa "$username"
      }
      create_smb_user dwt "${config.sops.secrets.dwt_password_plain.path}"
      create_smb_user vera "${config.sops.secrets.vera_password_plain.path}"
    '';
  };

  # Ensure Time Machine can discover the share without `tmutil`
  services.avahi = {
    extraServiceFiles = {
      timemachine = ''
        <?xml version="1.0" standalone='no'?>
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
            <service>
            <type>_device-info._tcp</type>
            <port>0</port>
            <txt-record>model=TimeCapsule8,119</txt-record>
          </service>
          <service>
            <type>_adisk._tcp</type>
            <txt-record>dk0=adVN=TimeMachine,adVF=0x82</txt-record>
            <txt-record>sys=waMa=0,adVF=0x100</txt-record>
          </service>
        </service-group>
      '';
    };
  };

}
