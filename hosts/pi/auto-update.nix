{
  system.autoUpgrade = {
    enable = true;
    # Syntax: "git+https://server.com/user/repo.git#hostname"
    flake = "git+https://github.com/dwt/home-servers.git#pi";
    flags = [
      "--update-input"
      "nixpkgs" # update only nixpkgs
      # "--commit-lock-file" # don't write back updates for now
    ];
    randomizedDelaySec = "45m"; # prevent server overload at 2`o clock
    allowReboot = true; # no restriction when the reboot can occur
    runGarbageCollection = true;
  };
}
