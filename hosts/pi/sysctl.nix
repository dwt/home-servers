{
  # Work around incompatible default in nixos or nixos-hardware
  boot.kernel.sysctl."vm.mmap_rnd_bits" = 18;
}
