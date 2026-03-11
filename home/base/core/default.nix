{ config, pkgs, ... }:

{
  imports = [
    ./editors
    ./shell.nix
    ./git.nix
    ./xdg.nix
    ./yazi.nix
    ./tmux.nix
  ];
}
