{ pkgs, ... }:

{
  #############################################################
  #
  #  General development workflow utilities
  #
  #  Language-specific tooling lives in languages.nix;
  #  format-specific tooling lives in data-formats.nix.
  #
  #############################################################

  home.packages = with pkgs; [
    just
    watchexec
    gdu
    gitleaks
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    config.global = {
      hide_env_diff = true;
    };
  };
}
