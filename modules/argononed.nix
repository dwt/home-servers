{
  pkgs,
  ...
}:
{
  # currently unused, as the argononed service in nixpkgs seems to do the trick
  # Argon ONe Daemon definition cobbled together from
  # nixpkgs package https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ar/argononed/package.nix
  # upstream package
  # https://gitlab.com/DarkElvenAngel/argononed/-/blob/master/NOTES.md
  # https://gitlab.com/DarkElvenAngel/argononed/-/blob/master/OS/nixos/pkg.nix
  # https://gitlab.com/DarkElvenAngel/argononed/-/blob/master/OS/nixos/default.nix
  # upstream i2c definitions  for argon one
  # https://github.com/Argon40Tech/Argon-ONE-i2c-Codes

  config = {
    environment.systemPackages = with pkgs; [
      # fan configuration for Argon One V2 Case
      argononed
    ];

    # allow daemon to talk to i2c
    hardware.raspberry-pi."4".i2c0.enable = true;
    hardware.raspberry-pi."4".i2c1.enable = true;

    # Daemon definition lifted from
    systemd = {
      services.argononed = {
        enable = true;
        after = [ "multi-user.target" ];
        wantedBy = [ "multi-user.target" ];
        description = "Argon ONE Fan and Button Daemon Service";

        serviceConfig = {
          # so the service can talk to i2c
          Group = "i2c";
          Type = "forking";
          ExecStart = "${pkgs.argononed}/bin/argononed";
          PIDFile = "/run/argononed.pid";
          Restart = "on-failure";
        };
      };

      shutdown = {
        argonone = "${pkgs.argononed}/argonone-shutdown";
      };
    };

    # FIXME this is a problem as this log will likely kill the sd card in the long term?
    services.logrotate.settings.argononed = {
      files = toString /var/log/argononed.log;
      rotate = 2;
      frequency = "daily";

      create = "660 root root";

      missingok = true;
      notifempty = true;

      compress = true;
      delaycompress = true;
    };

  };
}
