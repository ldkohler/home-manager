# work-ubuntu

Home Manager configuration for **lotus** — an Ubuntu work laptop that mirrors the environment from my NixOS setup (orchid). Same Niri window manager, Noctalia shell, Catppuccin theming, Apple fonts, dev tools, and shell config — just running on Ubuntu via standalone Home Manager instead of NixOS.

## What's inside

| Layer | What it provides |
|-------|-----------------|
| **Shell** | Zsh + Pure prompt, zoxide, eza, fzf, ripgrep, aliases |
| **Editor** | Neovim (vi/vim aliased) |
| **Git** | Full alias set, gh CLI, git-trim, git-lfs |
| **Dev tools** | direnv + nix-direnv, just, watchexec, gitleaks |
| **Languages** | Nix, Python, Go, Rust, Java, Bash, Lua, C/C++, Node/TypeScript — with LSPs, formatters, and linters |
| **Data formats** | TOML, YAML, JSON, Dockerfile, Markdown, SQL, Protobuf tooling |
| **Window manager** | Niri (scrollable tiling Wayland compositor) |
| **Desktop shell** | Noctalia Shell (panel, launcher, notifications, lock screen) |
| **Theme** | Catppuccin Mocha Blue — GTK, Qt/Kvantum, Papirus icons, WhiteSur cursors |
| **Terminal** | Ghostty + Alacritty |
| **Fonts** | Apple SF Pro, SF Mono, SF Compact, New York (+ Nerd Font variant) |
| **GUI apps** | Slack |
| **System utils** | btop, procs, fd, jq, yq, curl, wget, nmap, rsync, and more |

## Prerequisites

### 1. Determinate Nix

These systems come with [Determinate Nix](https://determinate.systems/nix/) pre-installed. Flakes are enabled by default — no extra configuration needed.

Verify it's working:
```bash
nix --version
```

### 2. Install Home Manager

```bash
nix run home-manager/master -- init
```

This isn't strictly required since we use `home-manager switch --flake`, but it ensures the `home-manager` command is available.

### 4. Install system dependencies (Ubuntu packages)

Some components need system-level packages that can't (or shouldn't) be managed by Nix:

```bash
# Wayland/graphics session support
sudo apt install -y \
  pipewire pipewire-pulse wireplumber \
  libwayland-client0 libwayland-cursor0 \
  xdg-desktop-portal xdg-desktop-portal-gtk \
  polkitd policykit-1 \
  dbus-user-session \
  libgl1 libegl1 libgles2 \
  libvulkan1 mesa-vulkan-drivers

# Login manager (if not already installed)
# GDM works well with Wayland sessions:
sudo apt install -y gdm3

# PAM integration for swaylock
sudo apt install -y libpam0g-dev
```

### 5. Clone this repo

```bash
cd ~
git clone <your-repo-url> work-ubuntu
cd work-ubuntu
```

## Setup checklist — TODOs to fill in before first use

Search for `TODO` across all files. Here's the full list:

| File | What to set |
|------|-------------|
| `home/home.nix` | `home.username` and `home.homeDirectory` |
| `home/base/core/git.nix` | `user.name` and `user.email` (work identity) |
| `home/linux/gui/base/noctalia/default.nix` | `confPath` — path to where you cloned this repo |
| `home/linux/gui/base/theme/default.nix` | `confPath` — path to where you cloned this repo |
| `home/linux/gui/niri/default.nix` | `confPath` — path to where you cloned this repo |
| `home/linux/gui/niri/conf/niri-hardware.kdl` | Display output config (run `niri msg outputs` to discover) |
| `home/linux/gui/base/noctalia/settings.json` | `location.name` (weather city), `wallpaper.directory`, `general.avatarImage` |

## Applying the configuration

### First time

```bash
cd ~/work-ubuntu

# Fill in all TODOs first, then:
nix run home-manager/master -- switch --flake .#lotus
```

### Ongoing updates

```bash
cd ~/work-ubuntu
home-manager switch --flake .#lotus
```

### If you get errors about conflicting files

Home Manager may refuse to overwrite existing dotfiles. Back them up first:
```bash
# Common conflicts:
mv ~/.config/zsh ~/.config/zsh.bak
mv ~/.config/gtk-3.0 ~/.config/gtk-3.0.bak
mv ~/.config/gtk-4.0 ~/.config/gtk-4.0.bak
mv ~/.bashrc ~/.bashrc.bak

# Then retry:
home-manager switch --flake .#lotus
```

## Post-switch manual steps

### 1. Register Niri as a Wayland session

The configuration installs a helper script. Run it once:

```bash
~/bin/setup-niri-session
```

This copies a `.desktop` file into `/usr/share/wayland-sessions/` so your display manager (GDM, SDDM, etc.) shows Niri as a session option.

### 2. Set up swaylock (screen locking)

On non-NixOS systems, swaylock needs elevated privileges to verify your password via PAM:

```bash
~/bin/setup-swaylock
```

### 3. Configure your display(s)

Once inside a Niri session, discover your outputs:

```bash
niri msg outputs
```

Then edit `home/linux/gui/niri/conf/niri-hardware.kdl` with the correct output names, resolutions, and positions. Re-apply:

```bash
home-manager switch --flake .#lotus
```

### 4. Set your default shell to Zsh

```bash
# Find the Nix-managed zsh
which zsh
# Add it to /etc/shells if not present
echo "$(which zsh)" | sudo tee -a /etc/shells
# Set as default
chsh -s "$(which zsh)"
```

### 5. Set up wallpapers

Create a wallpaper directory and update the Noctalia settings:

```bash
mkdir -p ~/Pictures/Wallpapers
# Copy some wallpapers in, then edit:
# home/linux/gui/base/noctalia/settings.json
#   → "wallpaper.directory": "/home/<you>/Pictures/Wallpapers"
```

### 6. Enable Noctalia systemd service

After the first `home-manager switch`, the service file is installed. Enable it:

```bash
systemctl --user enable --now noctalia-shell.service
```

If it doesn't start automatically with Niri, ensure your session sets the `wayland-wm.target`:
```bash
# Inside a running Niri session:
systemctl --user start noctalia-shell.service
```

### 7. Authenticate with GitHub CLI

```bash
gh auth login
```

## Updating flake inputs

```bash
cd ~/work-ubuntu
nix flake update
home-manager switch --flake .#lotus
```

To update a single input:
```bash
nix flake update home-manager
```

## Known differences from the NixOS setup

| Area | NixOS (orchid) | Ubuntu (lotus) |
|------|---------------|----------------|
| **System packages** | `environment.systemPackages` | `home.packages` (user-level) |
| **Fonts** | System-wide via `fonts.packages` + `fonts.fontconfig` | User-level via `home.packages` + `fonts.fontconfig` (Home Manager) |
| **Login manager** | greetd + tuigreet (Nix-managed) | GDM/SDDM (Ubuntu-managed, manual setup) |
| **Niri session** | `programs.niri.enable` auto-registers session | Manual `.desktop` file via setup script |
| **Swaylock** | Works out of the box (NixOS PAM integration) | Needs SUID bit set via setup script |
| **Polkit** | System service via NixOS module | Polkit agent run as systemd user service |
| **Bluetooth/Network** | Managed by NixOS modules | Managed by Ubuntu (NetworkManager, BlueZ) |
| **Browsers** | Firefox, Chrome, Zen Browser via Nix | Install manually outside Nix |
| **Audio** | PipeWire via NixOS module | PipeWire via Ubuntu apt packages |
| **Boot/Kernel/FS** | Fully Nix-managed (GRUB, LUKS, etc.) | Ubuntu-managed, not in scope |

## Directory structure

```
work-ubuntu/
├── flake.nix                              # Standalone flake — HM config for lotus
├── .gitignore
├── README.md
├── hosts/
│   └── lotus/
│       └── default.nix                    # Host-specific: display, Ubuntu workarounds, setup scripts
├── home/
│   ├── home.nix                           # Main HM entry point
│   ├── base/
│   │   ├── core/
│   │   │   ├── default.nix
│   │   │   ├── shell.nix                  # Zsh + Pure prompt, zoxide, eza, fzf, ripgrep
│   │   │   ├── git.nix                    # Git config (TODO: work identity)
│   │   │   ├── xdg.nix                    # XDG directories
│   │   │   ├── yazi.nix                   # Terminal file manager
│   │   │   ├── tmux.nix                   # Tmux
│   │   │   └── editors/
│   │   │       ├── default.nix
│   │   │       └── neovim/
│   │   │           └── default.nix        # Neovim
│   │   ├── gui/
│   │   │   ├── default.nix
│   │   │   └── apps.nix                   # Slack
│   │   └── dev/
│   │       ├── default.nix
│   │       ├── tools.nix                  # direnv, just, watchexec, gitleaks
│   │       ├── languages.nix              # All LSPs & language runtimes
│   │       └── data-formats.nix           # YAML, JSON, Docker, SQL, etc.
│   └── linux/
│       └── gui/
│           ├── default.nix
│           ├── base/
│           │   ├── default.nix
│           │   ├── noctalia/
│           │   │   ├── default.nix        # Noctalia shell + systemd service
│           │   │   └── settings.json      # Noctalia config (sanitized)
│           │   ├── theme/
│           │   │   ├── default.nix        # Catppuccin GTK/Qt/Kvantum theming
│           │   │   ├── qt6ct.conf
│           │   │   └── gtk-4.0/
│           │   │       └── gtk.css        # GTK4 color definitions
│           │   └── ghostty.nix            # Ghostty + Alacritty
│           └── niri/
│               ├── default.nix            # Niri module + polkit + session helpers
│               └── conf/
│                   ├── config.kdl         # Main Niri config (keybinds, layout, etc.)
│                   ├── niri-hardware.kdl  # Display config (TODO: configure for lotus)
│                   ├── noctalia-shell.kdl # Noctalia integration rules
│                   └── window-rules.kdl   # Per-app window rules
└── fonts/
    └── default.nix                        # Apple fonts + fontconfig defaults
```

## Troubleshooting

### Niri doesn't appear in display manager

Make sure you ran `~/bin/setup-niri-session` and that the `niri` binary is on your PATH. Log out and back in for the session to appear.

### Fonts look wrong

Ensure fontconfig is picking up the Nix-managed fonts:
```bash
fc-cache -fv
fc-list | grep "SF Pro"
```

If fonts aren't found, you may need to add the Nix font directory to your fontconfig search path. Home Manager usually handles this, but you can verify:
```bash
ls ~/.nix-profile/share/fonts/
```

### GTK theme not applying

Some Ubuntu apps may ignore the Home Manager GTK config. Ensure `gsettings` matches:
```bash
gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Mocha-Standard-Blue-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "WhiteSur-cursors"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
```

### swaylock refuses to lock

Verify the SUID bit was set correctly:
```bash
ls -la /usr/local/bin/swaylock
# Should show: -rwsr-xr-x
```

If it still fails, check PAM config:
```bash
cat /etc/pam.d/swaylock
# Should exist. If not, create it with:
sudo cp /etc/pam.d/login /etc/pam.d/swaylock
```

### Noctalia shell doesn't start

Check the systemd service:
```bash
systemctl --user status noctalia-shell.service
journalctl --user -u noctalia-shell.service
```

Common issues:
- `wayland-wm.target` not reached — ensure Niri is started as a session (not just the compositor)
- Qt platform plugin not found — verify `QT_QPA_PLATFORM=wayland;xcb` is set

### home-manager switch fails with "collision" errors

This means Home Manager is trying to create a file that already exists. Back up the conflicting file and retry:
```bash
# The error message will tell you which file. For example:
mv ~/.config/zsh/.zshrc ~/.config/zsh/.zshrc.bak
home-manager switch --flake .#lotus
```
# home-manager
