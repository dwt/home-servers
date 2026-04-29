# REFACT consider upstreaming, as standard auto update is kind of broken right now and does not allow specifying that specific inputs get updated
{ lib, pkgs, ... }:
let
  upgradeRepoPath = "/var/lib/nixos-upgrade-repo";
  repoURL = "https://github.com/dwt/home-servers.git";
  git-sync-service = "nixos-upgrade-pre-repo-sync";
in
{

  # TODO use OnFailure=notify-failure.service to send me a matrix notification
  system.autoUpgrade = {
    enable = true;
    # Syntax: "git+https://server.com/user/repo.git[#hostname]"
    # or "/path/to/repo[#hostname]"
    # could also use #${config.networking.hostName} to hardcode the current hostname if necessary
    flake = "${upgradeRepoPath}";
    flags = [
      # there should be support for flags here to update just the nixpkgs input
      # but `--update-inputs nixpkgs` and `--recreate-lockfile` where deprecated
      # and removed (as they where just handed through by nixos-rebuild to nix build anyway)
      # so now the job falls back to the pre-script
      # https://github.com/NixOS/nixpkgs/issues/349734
    ];
    randomizedDelaySec = "45m"; # prevent server overload at 2`o clock
    allowReboot = true; # no restriction when the reboot can occur
    runGarbageCollection = true;
  };

  # Repo needs to be checked out and owned by root - or I need additional config to tell root git that the repo is safe
  # https://wiki.nixos.org/wiki/Automatic_system_upgrades

  # ensure that the git repo directory is present
  systemd.tmpfiles.rules = [
    "d ${upgradeRepoPath} 0700 root root - -"
  ];

  # ensure the repo is checked out and current
  systemd.services.${git-sync-service} = {
    description = "Sync NixOS upgrade flake repository";
    serviceConfig = {
      Type = "oneshot";
      # Workaround for git hanging, possibly indefinitely, due to network issues
      # This fails this unit, preventing a system downgrade with an outdated repo
      TimeoutSec = "5m";
    };
    script = lib.getExe (
      pkgs.writeShellApplication {
        name = "sync-upgrade-repo";
        runtimeInputs = [
          pkgs.git
          pkgs.nix
        ];
        text = ''
          set -x
          cd ${upgradeRepoPath}
          if [ ! -d ".git" ]; then
            git clone ${repoURL} .
          else
            git fetch origin
            git reset --hard "@{upstream}"
          fi
          # Update only nixpkgs as we want to get security updates
          nix flake update nixpkgs
        '';
      }
    );
  };

  # ensure nixos-upgrade auto pulls git changes before running the upgrade
  systemd.services.nixos-upgrade.after = [ "${git-sync-service}.service" ];
  systemd.services.nixos-upgrade.wants = [ "${git-sync-service}.service" ];
}
