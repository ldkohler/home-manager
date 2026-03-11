# Host-specific configuration for lotus (Ubuntu work laptop)
#
# This module handles anything that varies per-machine:
# display outputs, systemd user services, Ubuntu workarounds, etc.
{ config, pkgs, lib, ... }:

{
  # Ubuntu-specific session environment
  home.sessionVariables = {
    # Ensure Niri is discoverable as a Wayland session
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
  };

  # Niri needs a .desktop session file for display managers.
  # On NixOS this is handled by programs.niri.enable; on Ubuntu we
  # create a helper script that copies it into place (requires sudo).
  #
  # Run the setup script once after first `home-manager switch`:
  #   ~/bin/setup-niri-session
  home.file."bin/setup-niri-session" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      NIRI="$(command -v niri)"
      SESSION_DIR="/usr/share/wayland-sessions"
      DESKTOP_FILE="$SESSION_DIR/niri.desktop"

      if [ ! -d "$SESSION_DIR" ]; then
        echo "Creating $SESSION_DIR ..."
        sudo mkdir -p "$SESSION_DIR"
      fi

      echo "Writing $DESKTOP_FILE ..."
      sudo tee "$DESKTOP_FILE" > /dev/null <<DESKTOP
      [Desktop Entry]
      Name=Niri
      Comment=A scrollable-tiling Wayland compositor
      Exec=$NIRI --session
      Type=Application
      DesktopNames=niri
      DESKTOP

      echo "Done. Log out and select 'Niri' from your display manager."
    '';
  };

  # swaylock needs setuid on non-NixOS. This script sets it up once.
  home.file."bin/setup-swaylock" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      SWAYLOCK="$(command -v swaylock)"
      if [ -z "$SWAYLOCK" ]; then
        echo "swaylock not found in PATH"
        exit 1
      fi

      # Copy to /usr/local/bin and set SUID so it can lock the session
      echo "Copying swaylock to /usr/local/bin and setting permissions..."
      sudo cp "$SWAYLOCK" /usr/local/bin/swaylock
      sudo chmod u+s /usr/local/bin/swaylock

      echo "Done. swaylock is now usable for screen locking."
    '';
  };

  # Extra packages useful on Ubuntu that NixOS provides at system level
  home.packages = with pkgs; [
    # Wayland session utilities
    niri
    swaylock
    wl-clipboard
    playerctl
    brightnessctl
    waybar

    # System utilities (on NixOS these are in environment.systemPackages)
    fastfetch
    btop
    procs
    zip
    xz
    zstd
    unzip
    p7zip
    jq
    yq-go
    jc
    fd
    findutils
    duf
    dust
    ncdu
    wget
    curl
    curlie
    httpie
    socat
    nmap
    rsync
    file
    which
    tree
    tealdeer
    sad
    gnugrep
  ];
}
