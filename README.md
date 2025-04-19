# ❄️ Zloutek1's NixOS & Home-Manager Configuration

A modern, modular NixOS configuration.

## ✨ Features

- **Declarative Configuration**: Everything defined as code using Nix flakes 
- **Modular Design**: Clean separation between system and user configuration
- **Hyprland Compositor**: Modern Wayland-based environment with custom theming
- **Dynamic Theming**: Auto-generated themes based on wallpaper using Matugen
- **Hardware Optimizations**: Specific configurations for Lenovo Yoga 16IMH9

## 🏗️ Structure

```bash
.
├── flake.nix         # Entry point for the configuration
├── homes/            # Home-manager configurations
├── hosts/            # Machine-specific configurations
├── lib/              # Helper functions and utilities
├── modules/          # Reusable configuration modules
│   ├── hardware/     # Hardware-specific configurations
│   ├── home-manager/ # User environment modules
│   └── nixos/        # System-level modules
└── pkgs/             # Custom packages
```

## 📦 Main Components

### System Configuration

- **Audio**: PipeWire
- **Graphics**: Wayland
- **Fonts**: Modern font selection
- **Bootloader**: GRUB with Matrix theme

### User Environment

- **Window Manager**: Hyprland
- **Terminal**: Kitty
- **Editor**: Neovim
- **Bar**: Waybar
- **Notification**: Mako notification daemon
- **App Launcher**: Wofi
- **Dynamic Wallpapers**: Script-based wallpaper management with theme generation

## 🚀 Getting Started

### Prerequisites

- NixOS installation
- Git

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/zloutek1/nixos.git ~/.config/nix
   cd ~/.config/nix
   ```

2. Apply the configuration (replace 'yoga' with your hostname if different):
   ```bash
   sudo nixos-rebuild switch --flake .#yoga
   ```

## 🔧 Customization

### Adding a New Host

1. Create a new directory under `hosts/`:
   ```bash
   mkdir -p hosts/new-machine
   ```

2. Create `default.nix` and `hardware.nix` files in the new directory.

3. Update the `flake.nix` to include your new machine:
   ```nix
   nixosConfigurations = {
     yoga = lib.mkNixosSystem {...};
     new-machine = lib.mkNixosSystem {...};
   };
   ```

### Adding a New User

1. Create a new directory under `homes/`:
   ```bash
   mkdir -p homes/newuser
   ```

2. Create a `default.nix` file in the new directory with your user configuration.

3. Update the `flake.nix` and point your machine to have the new user:
   ```nix
   nixosConfigurations = {
     yoga = lib.mkNixosSystem {...};
     new-machine = lib.mkNixosSystem {
        user = "newuser";
        ...
     };
   };
   ```

## 🎨 Theming

The configuration uses a dynamic theming system based on your wallpaper. The `wallpaper` module in home-manager handles:

- Wallpaper cycling
- Theme generation using Matugen
- Applying themes to all components (Hyprland, Kitty, Waybar, etc.)

Commands:
- `next-wallpaper`: Switch to the next wallpaper and update themes
- `pick-wallpaper`: Open a selector to choose a specific wallpaper
- `update-colors`: Regenerate theme colors from the current wallpaper

## 🛠️ Hardware-Specific Optimizations

The configuration includes specific optimizations for the Lenovo Yoga 16IMH9:
- Audio fixes with custom script
- Graphics optimizations 
- Power management settings
- Touchscreen and tablet mode configuration

## 🙏 Acknowledgments

- [NixOS](https://nixos.org/) for the amazing Linux distribution
- [Home Manager](https://github.com/nix-community/home-manager) for user environment management
- [Hyprland](https://hyprland.org/) for the excellent Wayland compositor
- [JaKooLit Hyprland Dots](https://github.com/JaKooLit/Hyprland-Dots/releases) for wallpaper select rofi theme
- [Adi1090x Rofi Dots](https://github.com/adi1090x/rofi) for Rofi launcher theme
- Various open-source project contributors that made this configuration possible