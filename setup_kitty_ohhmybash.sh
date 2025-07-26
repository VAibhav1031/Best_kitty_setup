#!/bin/bash

GITHUB_REPO="https://raw.githubusercontent.com/VAibhav1031/Best_kitty_setup/main"

echo_color() {
  echo -e "\e[1;32m$1\e[0m"
}

if command -v dnf &>/dev/null; then
  PKG_MANAGER="dnf"
elif command -v apt &>/dev/null; then
  PKG_MANAGER="apt"
elif command -v pacman &>/dev/null; then
  PKG_MANAGER="pacman"
else
  echo_color "No compatible package manager found. Please install the required packages manually."
  exit 1
fi

# 1. Installing  Kitty
echo_color "Installing Kitty terminal..."
if [[ "$PKG_MANAGER" == "dnf" ]]; then
  sudo dnf install kitty -y
elif [[ "$PKG_MANAGER" == "apt" ]]; then
  sudo apt update && sudo apt install kitty -y
elif [[ "$PKG_MANAGER" == "pacman" ]]; then
  sudo pacman -S kitty --noconfirm
fi

# Checking  if Kitty was installed successfully or not
if ! command -v kitty &>/dev/null; then
  echo_color "Failed to install Kitty. Please check your package manager."
  exit 1
fi

# 2. Downloading Kitty config from GitHub
echo_color "Downloading and configuring Kitty..."
mkdir -p ~/.config/kitty
curl -o ~/.config/kitty/kitty.conf "$GITHUB_REPO/kitty.conf"

# 3. Installing  Oh My Bash
echo_color "Installing Oh My Bash..."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# 4. It will change  the theme to Kitsune  from Default Font
echo_color "Changing Oh My Bash theme to Kitsune..."
sed -i 's/OSH_THEME=".*"/OSH_THEME="kitsune"/g' ~/.bashrc

# 5. Installing lolcat and figlet
echo_color "Installing lolcat and figlet..."
if [[ "$PKG_MANAGER" == "dnf" ]]; then
  sudo dnf install figlet lolcat -y
elif [[ "$PKG_MANAGER" == "apt" ]]; then
  sudo apt update && sudo apt install figlet lolcat -y
elif [[ "$PKG_MANAGER" == "pacman -S" ]]; then
  sudo pacman -S figlet lolcat --noconfirm
fi

# Modifying the  .bashrc
echo_color "Adding a custom banner to .bashrc..."
if ! grep -q "figlet \" Welcome to Kitty\"" ~/.bashrc; then
  cat <<'EOF' >>~/.bashrc

# Display custom banner using figlet and lolcat
if command -v figlet &> /dev/null && command -v lolcat &> /dev/null; then
    figlet "Welcome to Kitty" | lolcat
fi
EOF
fi

echo_color "Setup completed! Please restart Kitty for changes to take effect."
