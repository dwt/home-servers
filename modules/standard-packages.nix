{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # nix debugging
    nix-tree

    # my dependencies
    rmate-sh
    glances
    btop
  ];

}
