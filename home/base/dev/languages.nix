{ config, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  #############################################################
  #
  #  Language runtimes, LSPs, formatters & linters
  #
  #  Philosophy:
  #    - Enough tooling for editor integration & quick scripting
  #    - Heavy, project-specific deps belong in per-project devShells
  #    - direnv + nix-direnv auto-activates devShells on cd
  #
  #############################################################

  home.packages = with pkgs;

    #-*- Nix -*-#
    [
      nil
      nixd
      statix
      deadnix
      nixfmt
      colmena
    ]

    #-*- Python -*-#
    ++ [
      python312
      ruff
      pyright
      mypy
      uv
    ]

    #-*- Go -*-#
    ++ [
      go
      gopls
      gotools
      gomodifytags
      impl
      iferr
      delve
      golangci-lint
      gofumpt
      golines
      revive
    ]

    #-*- Rust (via rust-overlay) -*-#
    ++ [
      (rust-bin.stable.latest.default.override {
        extensions = [
          "rust-src"
          "rust-analyzer"
          "clippy"
          "rustfmt"
        ];
      })
    ]

    #-*- Java -*-#
    ++ [
      jdk17
      gradle
      maven
      spring-boot-cli
      jdt-language-server
    ]

    #-*- Bash -*-#
    ++ [
      shellcheck
      shfmt
      nodePackages.bash-language-server
    ]

    #-*- Lua -*-#
    ++ [
      lua-language-server
      stylua
      selene
    ]

    #-*- C / C++ (shared) -*-#
    ++ [
      clang-tools
      cpplint
      cppcheck
      include-what-you-use
      gnumake
      cmake
      cmake-language-server
      checkmake
      pkg-config
    ]

    #-*- C / C++ (platform-specific) -*-#
    ++ lib.optionals isLinux [
      gcc
      gdb
    ]

    #-*- Web (Node / TypeScript) -*-#
    ++ [
      nodejs_22
      pnpm
      typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages."@tailwindcss/language-server"
      emmet-ls
      prettierd
      biome
      eslint
    ];

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/.local/share/go";
    GOBIN = "${config.home.homeDirectory}/.local/share/go/bin";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/share/go/bin"
  ];
}
