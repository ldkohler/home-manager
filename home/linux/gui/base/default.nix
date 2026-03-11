{ config, pkgs, ... }:

{
  imports = [
    ./noctalia
    ./theme
    ./ghostty.nix
  ];
}
