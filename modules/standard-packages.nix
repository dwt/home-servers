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
    fresh # terminal editor which approximates ui editors
  ];
}
