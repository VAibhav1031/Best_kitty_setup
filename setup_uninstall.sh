#!/bin/bash

if command -v dnf &>/dev/null; then
  PKG_MANAGER="dnf"
elif command -v apt &>/dev/null; then
  PKG_MANAGER="apt"
elif command -v pacman &>/dev/null; then
  PKG_MANAGER="pacman"
else
  echo "No compatible package manager found."
  exit 1
fi

# Restores the original .bashrc
if [[ -f ~/.bashrc.bak ]]; then
  echo "Restoring original .bashrc..."
  mv ~/.bashrc.bak ~/.bashrc
else
  echo "No backup found. .bashrc will not be restored."
fi

# Remove Oh My Bash
if [[ -d ~/.oh-my-bash ]]; then
  echo "Removing Oh My Bash..."
  rm -rf ~/.oh-my-bash
fi

# Uninstalling the  packages
echo "Uninstalling installed packages..."
if [[ "$PKG_MANAGER" == "dnf" ]]; then
  sudo dnf remove kitty figlet lolcat -y
elif [[ "$PKG_MANAGER" == "apt" ]]; then
  sudo apt remove --purge kitty figlet lolcat -y
elif [[ "$PKG_MANAGER" == "pacman" ]]; then
  sudo pacman -Rns kitty figlet lolcat --noconfirm
fi

echo "Cleanup completed!"

# Yeaahuu
