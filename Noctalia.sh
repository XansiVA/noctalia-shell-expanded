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
    kitty gnome-text-editor oh-my-posh \
    xwayland-satellite gnome-keyring corectl \
    networkmanager vesktop 

# Step 3: Copy configuration files
REPO_DIR="$HOME/noctalia-shell-expanded"

# Niri config
echo -e "${GREEN}Copying Niri configuration...${RESET}"
NIRI_SRC="$REPO_DIR/config.kdl"
NIRI_DEST="$HOME/.config/niri/config.kdl"
mkdir -p "$(dirname "$NIRI_DEST")"
cp "$NIRI_SRC" "$NIRI_DEST"

# Fuzzel config Noctalia shell already edits this file.
#echo -e "${GREEN}Copying Fuzzel configuration...${RESET}"
#FUZZEL_SRC="$REPO_DIR/fuzzel.ini"
#FUZZEL_DEST="$HOME/.config/fuzzel/fuzzel.ini"
#mkdir -p "$(dirname "$FUZZEL_DEST")"
#cp "$FUZZEL_SRC" "$FUZZEL_DEST"

# Desktop file
echo -e "${GREEN}Copying desktop file...${RESET}"
DESKTOP_SRC="$REPO_DIR/NoctaliaQS.desktop"
DESKTOP_DEST="$HOME/.local/share/applications/noctalia.desktop"
mkdir -p "$(dirname "$DESKTOP_DEST")"
cp "$DESKTOP_SRC" "$DESKTOP_DEST"

# Kitty config
echo -e "${GREEN}Copying Kitty configuration...${RESET}"
KITTY_SRC="$REPO_DIR/kitty.conf"
KITTY_DEST="$HOME/.config/kitty/kitty.conf"
mkdir -p "$(dirname "$KITTY_DEST")"
cp "$KITTY_SRC" "$KITTY_DEST"

# Bashrc
echo -e "${GREEN}Replacing .bashrc...${RESET}"
BASHRC_SRC="$REPO_DIR/.bashrc"
BASHRC_DEST="$HOME/.bashrc"
rm -f "$BASHRC_DEST"
cp "$BASHRC_SRC" "$BASHRC_DEST"

echo -e "${GREEN}=== Setup complete! ===${RESET}"
sleep 1
