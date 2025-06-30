{ pkgs, pkgs-unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    # nix debugging
    pkgs-unstable.nix-tree

    # my dependencies
    rmate-sh
    glances
    btop
    ncdu
    jq
    yq-go
  ];
}
