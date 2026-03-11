{ config, pkgs, ... }:

{
  imports = [
    ./linux/gui/default.nix
    ./base/core/default.nix
    ./base/gui/default.nix
    ./base/dev/default.nix
    ../fonts
  ];

  # TODO: Set your work username and home directory
  home.username = "luke";  # TODO: Change to your work username
  home.homeDirectory = "/home/luke";  # TODO: Change to match

  home.packages = with pkgs; [
    ldns
  ];

  modules.desktop.niri.enable = true;

  home.stateVersion = "25.11";
}
