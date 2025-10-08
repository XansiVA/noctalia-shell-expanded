#!/bin/bash
set -e

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${GREEN}=== Arch Linux Setup Script (paru-based) ===${RESET}"

# Check if packages are already installed
PACKAGES_TO_CHECK="quickshell ttf-roboto inter-font gpu-screen-recorder brightnessctl ddcutil cliphist matugen cava wlsunset xdg-desktop-portal kitty gnome-text-editor oh-my-posh xwayland-satellite gnome-keyring corectl networkmanager vesktop fzf grim slurp satty fastfetch"

ALL_INSTALLED=true
for pkg in $PACKAGES_TO_CHECK; do
    if ! pacman -Qi "$pkg" &> /dev/null && ! paru -Qi "$pkg" &> /dev/null; then
        ALL_INSTALLED=false
        break
    fi
done

if [ "$ALL_INSTALLED" = true ]; then
    echo -e "${YELLOW}All packages already installed! Skipping installation steps...${RESET}"
else
    # Step 1: Install paru if not installed
    if ! command -v paru &> /dev/null; then
        echo -e "${GREEN}Installing paru...${RESET}"
        sudo pacman -S --needed --noconfirm base-devel git
        git clone https://aur.archlinux.org/paru.git /tmp/paru
        cd /tmp/paru
        makepkg -si --noconfirm
        cd -
    else
        echo -e "${GREEN}paru already installed!${RESET}"
    fi

    # Step 2: Install official repo packages first
    echo -e "${GREEN}Installing official repository packages...${RESET}"
    sudo pacman -S --needed --noconfirm \
        ttf-roboto inter-font brightnessctl ddcutil cliphist cava wlsunset \
        xdg-desktop-portal kitty gnome-text-editor gnome-keyring \
        networkmanager fzf grim slurp fastfetch
    
    # Step 3: Install AUR packages (specify non-git versions)
    echo -e "${GREEN}Installing AUR packages...${RESET}"
    paru -S --needed --noconfirm \
        quickshell-git \
        gpu-screen-recorder \
        oh-my-posh-bin \
        matugen-bin \
        xwayland-satellite \
        vesktop-bin \
        satty \
        noctalia-shell
fi

# Step 3: Copy configuration files
REPO_DIR="$HOME/noctalia-shell-expanded"

echo -e "${GREEN}Copying configuration files...${RESET}"

# Niri config
echo -e "${GREEN}Copying Niri configuration...${RESET}"
NIRI_SRC="$REPO_DIR/config.kdl"
NIRI_DEST="$HOME/.config/niri/config.kdl"
mkdir -p "$(dirname "$NIRI_DEST")"
cp "$NIRI_SRC" "$NIRI_DEST"

# Desktop file
echo -e "${GREEN}Copying desktop file...${RESET}"
DESKTOP_SRC="$REPO_DIR/NoctaliaQS.desktop"
DESKTOP_DEST="$HOME/.local/share/applications/noctalia.desktop"
mkdir -p "$(dirname "$DESKTOP_DEST")"
cp "$DESKTOP_SRC" "$DESKTOP_DEST"

# Kitty config
#echo -e "${GREEN}Copying Kitty configuration...${RESET}"
#KITTY_SRC="$REPO_DIR/kitty.conf"
#KITTY_DEST="$HOME/.config/kitty/kitty.conf"
#mkdir -p "$(dirname "$KITTY_DEST")"
#cp "$KITTY_SRC" "$KITTY_DEST"

# Fuzzel config
#echo -e "${GREEN}Copying Fuzzel configuration...${RESET}"
#FUZZEL_SRC="$REPO_DIR/fuzzel.ini"
#FUZZEL_DEST="$HOME/.config/fuzzel/fuzzel.ini"
#mkdir -p "$(dirname "$FUZZEL_DEST")"
#cp "$FUZZEL_SRC" "$FUZZEL_DEST"

# Bashrc
echo -e "${GREEN}Replacing .bashrc...${RESET}"
BASHRC_SRC="$REPO_DIR/.bashrc"
BASHRC_DEST="$HOME/.bashrc"
rm -f "$BASHRC_DEST"
cp "$BASHRC_SRC" "$BASHRC_DEST"

# Fastfetch config
echo -e "${GREEN}Creating fastfetch configuration...${RESET}"
FASTFETCH_DIR="$HOME/.config/fastfetch"
mkdir -p "$FASTFETCH_DIR"
cat > "$FASTFETCH_DIR/config.jsonc" << 'EOF'
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "auto",
        "padding": {
            "top": 1,
            "right": 3
        }
    },
    "display": {
        "separator": " ╰─",
        "key": {
            "width": 18,
            "paddingLeft": 2
        },
        "percent": {
            "type": 3
        },
        "size": {
            "binaryPrefix": "si"
        },
        "color": {
            "keys": "blue",
            "title": "cyan"
        }
    },
    "modules": [
        {
            "type": "custom",
            "format": "┌──────────────────────────────────────────────┐"
        },
        {
            "type": "title",
            "keyColor": "cyan",
            "color": {
                "user": "cyan",
                "at": "white",
                "host": "blue"
            }
        },
        {
            "type": "custom",
            "format": "├──────────────────────────────────────────────┤"
        },
        {
            "type": "os",
            "key": "  OS",
            "keyColor": "blue"
        },
        {
            "type": "kernel",
            "key": "  Kernel",
            "keyColor": "blue"
        },
        {
            "type": "packages",
            "key": "  Packages",
            "keyColor": "blue"
        },
        {
            "type": "shell",
            "key": "  Shell",
            "keyColor": "blue"
        },
        {
            "type": "wm",
            "key": "  WM",
            "keyColor": "blue"
        },
        {
            "type": "terminal",
            "key": "  Terminal",
            "keyColor": "blue"
        },
        {
            "type": "uptime",
            "key": "  Uptime",
            "keyColor": "blue"
        },
        {
            "type": "custom",
            "format": "├──────────────────────────────────────────────┤"
        },
        {
            "type": "cpu",
            "key": "  CPU",
            "keyColor": "green"
        },
        {
            "type": "gpu",
            "key": "  GPU",
            "keyColor": "green"
        },
        {
            "type": "memory",
            "key": "  Memory",
            "keyColor": "yellow"
        },
        {
            "type": "disk",
            "key": "  Disk",
            "keyColor": "yellow"
        },
        {
            "type": "custom",
            "format": "└──────────────────────────────────────────────┘"
        },
        "break",
        {
            "type": "colors",
            "paddingLeft": 2,
            "symbol": "circle"
        }
    ]
}
EOF

echo -e "${GREEN}=== Setup complete! ===${RESET}"
sleep 1
clear 
# Config editor menu
echo -e "${YELLOW}Would you like to edit configuration files? (y/n)${RESET}"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Searching for config files in ~/.config...${RESET}"
    
    # Find all config files with specified extensions
    CONFIG_FILE=$(find "$HOME/.config" -type f \( \
        -name "*.conf" -o \
        -name "*.config" -o \
        -name "*.toml" -o \
        -name "*.kdl" -o \
        -name "*.json" -o \
        -name "*.jsonc" -o \
        -name "*.ini" \
    \) 2>/dev/null | fzf --prompt="Select a config file to edit: " --height=40% --border)
    
    if [ -n "$CONFIG_FILE" ]; then
        echo -e "${GREEN}Opening $CONFIG_FILE...${RESET}"
        ${EDITOR:-nano} "$CONFIG_FILE"
        
        # Ask if they want to edit another
        while true; do
            echo -e "${YELLOW}Edit another config file? (y/n)${RESET}"
            read -r again
            if [[ "$again" =~ ^[Yy]$ ]]; then
                CONFIG_FILE=$(find "$HOME/.config" -type f \( \
                    -name "*.conf" -o \
                    -name "*.config" -o \
                    -name "*.toml" -o \
                    -name "*.kdl" -o \
                    -name "*.json" -o \
                    -name "*.jsonc" -o \
                    -name "*.ini" \
                \) 2>/dev/null | fzf --prompt="Select a config file to edit: " --height=40% --border)
                
                if [ -n "$CONFIG_FILE" ]; then
                    echo -e "${GREEN}Opening $CONFIG_FILE...${RESET}"
                    ${EDITOR:-nano} "$CONFIG_FILE"
                else
                    break
                fi
            else
                break
            fi
        done
    fi
fi
clear
echo -e "${GREEN}All done! Enjoy your Noctalia setup! 🌙${RESET}"
sleep 1
