{ pkgs, pkgs-unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    # nix debugging
    nix-tree

    # my dependencies
    rmate-sh # remote editor client for TextMate remote editing
    btop # resource monitor
    ncdu # disk usage analyzer
    jq # JSON processor
    yq-go # YAML processor
    bat # better cat

    # dev stuff
    pkgs-unstable.fresh-editor # terminal editor which approximates ui editors
    git # distributed version control
    lazygit # git tui
    prek
  ];

  programs.direnv.enable = true; # auto activate development environments on entering directories
}
