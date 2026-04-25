{
  # Does not quite do what I want yet. When it points to a git repo, I cannot use `--update-input nixpkgs`
  # So I need to prepare a git checkout, but I do not know yet how to do that from nix.
  # And just pointing to a git repo means I loose updates I push locally when I forget to also push them to git
  system.autoUpgrade = {
    enable = false;
    # Syntax: "git+https://server.com/user/repo.git#hostname"
    flake = "git+https://github.com/dwt/home-servers.git#pi";
    flags = [
      # these don't work when using flake reference
      # "--update-input" "nixpkgs" # update only nixpkgs
      # "--commit-lock-file" # don't write back updates for now
    ];
    randomizedDelaySec = "45m"; # prevent server overload at 2`o clock
    allowReboot = true; # no restriction when the reboot can occur
    runGarbageCollection = true;
  };
}
