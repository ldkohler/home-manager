{ pkgs, ... }:

{
  #############################################################
  #
  #  Data & configuration format tooling
  #
  #  LSPs, linters, and utilities for non-programming languages:
  #  markup, config formats, IaC, and query languages.
  #
  #############################################################

  home.packages = with pkgs; [
    #-*- TOML / YAML / JSON -*-#
    taplo
    nodePackages.yaml-language-server
    yamllint
    jsonnet
    jsonnet-language-server

    #-*- CI / Containers -*-#
    actionlint
    hadolint
    dockerfile-language-server

    #-*- Markdown / Prose -*-#
    marksman
    glow
    pandoc
    proselint

    #-*- SQL -*-#
    sqlfluff
    sqls

    #-*- Protocol Buffers -*-#
    buf
  ];
}
