{ config, pkgs, ... }:

{
  imports = [
    ./tools.nix
    ./languages.nix
    ./data-formats.nix
  ];
}
