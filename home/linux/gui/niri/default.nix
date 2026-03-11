{ pkgs, config, lib, ... }:

let
  cfg = config.modules.desktop.niri;

  mkSymlink = config.lib.file.mkOutOfStoreSymlink;

  # TODO: Update this path to match where you clone this repo on lotus
  confPath = "${config.home.homeDirectory}/work-ubuntu/home/linux/gui/niri/conf";
in
{
  options.modules.desktop.niri = {
    enable = lib.mkEnableOption "niri (Home Manager config + session helpers)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Needed for GUI privilege prompts (polkit agent)
      kdePackages.polkit-kde-agent-1

      # Xwayland compatibility for legacy X11 apps
      xwayland-satellite
    ];

    # Symlink your Niri KDL config from your repo into ~/.config/niri/
    xdg.configFile = {
      "niri/config.kdl".source = mkSymlink "${confPath}/config.kdl";
      "niri/niri-hardware.kdl".source = mkSymlink "${confPath}/niri-hardware.kdl";
      "niri/noctalia-shell.kdl".source = mkSymlink "${confPath}/noctalia-shell.kdl";
      "niri/window-rules.kdl".source = mkSymlink "${confPath}/window-rules.kdl";
    };

    # Run a polkit authentication agent in your user session
    systemd.user.services.niri-polkit-agent = {
      Unit = {
        Description = "PolicyKit Authentication Agent (Niri session)";
        After = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
      };

      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # On Ubuntu we don't have greetd/tuigreet launching .wayland-session.
    # Instead, the display manager (GDM/SDDM/etc.) launches niri directly
    # via the .desktop session file installed by ~/bin/setup-niri-session.
    # This script is kept as a fallback for TTY login.
    home.file.".wayland-session" = {
      source = pkgs.writeScript "init-session" ''
        #!/usr/bin/env sh
        set -eu

        # If there is an existing niri user service, stop it (safe no-op otherwise)
        if systemctl --user is-active --quiet niri.service; then
          systemctl --user stop niri.service
        fi

        # Start niri session — on Ubuntu, niri is installed via home.packages
        exec niri --session
      '';
      executable = true;
    };
  };
}
