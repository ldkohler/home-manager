# Apple fonts and fontconfig for Home Manager (non-NixOS)
#
# On NixOS, fonts are installed system-wide via fonts.packages.
# On Ubuntu, we install them into the user profile and configure
# fontconfig via Home Manager.
{ config, pkgs, lib, inputs, ... }:

{
  home.packages = [
    # Apple Fonts
    inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro
    inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-compact
    inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-mono
    inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.ny

    inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-mono-nerd
  ];

  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      serif = [
        "New York Medium"
        "New York"
      ];
      sansSerif = [
        "SF Pro Display"
        "SF Pro Text"
      ];
      monospace = [
        "SF Mono"
        "SFMono Nerd Font"
      ];
      emoji = [
        "Apple Color Emoji"
      ];
    };
  };
}
