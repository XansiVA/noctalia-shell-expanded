#!/bin/bash
set -e

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${GREEN}=== Arch Linux Setup Script (paru-based) ===${RESET}"

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

# Step 2: Install packages
echo -e "${GREEN}Installing required packages...${RESET}"
paru -S --needed --noconfirm \
    quickshell ttf-roboto inter-font gpu-screen-recorder brightnessctl \
    ddcutil cliphist matugen cava wlsunset xdg-desktop-portal \
    visual-studio-code-bin intellij-idea-community-edition \
    firefox kitty

# Step 3: Example file copy (customize paths!)
SRC_FILE="$HOME/Downloads/example.conf"
DEST_DIR="$HOME/.config/example"
DEST_FILE="$DEST_DIR/example.conf"

echo -e "${GREEN}Copying $SRC_FILE → $DEST_FILE${RESET}"
mkdir -p "$DEST_DIR"
cp "$SRC_FILE" "$DEST_FILE"

echo -e "${GREEN}=== Setup complete! 🎉 ===${RESET}"

