{ pkgs, pkgs-unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    # nix debugging
    pkgs-unstable.nix-tree

    # my dependencies
    rmate-sh
    btop
    ncdu
    jq
    yq-go
    helix
  ];
}
