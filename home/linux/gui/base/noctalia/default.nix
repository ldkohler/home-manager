{ config, pkgs, lib, inputs, ... }:

let
  package = pkgs.noctalia-shell;
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  # TODO: Update this path to match where you clone this repo on lotus
  confPath = "${config.home.homeDirectory}/work-ubuntu/home/linux/gui/base/noctalia";
in
{
  home.packages = [
    package
    pkgs.qt6Packages.qt6ct
    pkgs.app2unit
  ]
  ++ (lib.optionals pkgs.stdenv.isx86_64 [
    pkgs.gpu-screen-recorder
  ]);

  # xdg symlink
  xdg.configFile."noctalia/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink
      "${confPath}/settings.json";

  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell - Wayland desktop shell";
      Documentation = "https://docs.noctalia.dev/docs";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target ];
    };

    Service = {
      ExecStart = lib.getExe package;
      Restart = "on-failure";

      Environment = [
        "QT_QPA_PLATFORM=wayland;xcb"
        "QT_QPA_PLATFORMTHEME=qt6ct"
        "QT_AUTO_SCREEN_SCALE_FACTOR=1"
      ];
    };

    Install.WantedBy = [ config.wayland.systemd.target ];

  };
}
