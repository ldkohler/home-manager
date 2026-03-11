{ config, pkgs, lib, ... }:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  # TODO: Update this path to match where you clone this repo on lotus
  confPath = "${config.home.homeDirectory}/work-ubuntu/home/linux/gui/base/theme";
  # Catppuccin choices
  gtkThemeName = "Catppuccin-Mocha-Standard-Blue-Dark";
  isDark = true;
  iconThemeName = "Papirus-Dark";
in
{
  home.packages = [
    # Qt theming
    pkgs.qt6Packages.qt6ct
    pkgs.libsForQt5.qtstyleplugin-kvantum
    pkgs.qt6Packages.qtstyleplugin-kvantum
    pkgs.catppuccin-kvantum

    # GTK theme
    (pkgs.catppuccin-gtk.override {
      accents = [ "blue" ];
      variant = "mocha";
      tweaks = [ "normal" ];
    })
    # Icons
    (pkgs.catppuccin-papirus-folders.override {
      flavor = "mocha";
      accent = "blue";
    })

    pkgs.whitesur-cursors
  ];
  # Symlink qt6ct config
  xdg.configFile."qt6ct/qt6ct.conf".source =
    mkSymlink "${confPath}/qt6ct.conf";
  xdg.configFile."gtk-4.0/gtk.css" = {
    source = mkSymlink "${confPath}/gtk-4.0/gtk.css";
    force = true;
  };

  # Kvantum config for Catppuccin
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Catppuccin-Mocha-Blue
  '';

  home.pointerCursor = {
    name = "WhiteSur-cursors";
    package = pkgs.whitesur-cursors;
    size = 24;
    gtk.enable = true;
  };

  # GTK via Home Manager
  gtk = {
    enable = true;
    theme = {
      name = gtkThemeName;
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        variant = "mocha";
	tweaks = [ "rimless" "normal" ];
      };
    };
    iconTheme = {
      name = iconThemeName;
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
    };
    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = if isDark then 1 else 0;
    };
    gtk4.extraConfig = {
      "gtk-application-prefer-dark-theme" = if isDark then 1 else 0;
    };
  };
  # Qt env vars at the session level so ALL Qt apps obey qt6ct
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "kvantum";
    QT_STYLE_OVERRIDE = "kvantum";
  };
}
