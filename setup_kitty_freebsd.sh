#!/usr/bin/env bash

# GitHub repo path
GITHUB_REPO="https://raw.githubusercontent.com/VAibhav1031/Best_kitty_setup/main"

# Colored echo function
echo_color() {
  echo -e "\033[1;32m$1\033[0m"
}

# Check for pkg
if ! command -v pkg &>/dev/null; then
  echo_color "Error: FreeBSD 'pkg' not found. Exiting."
  exit 1
fi

# Install dependencies
echo_color "Installing required packages: kitty, figlet, lolcat, bash, curl..."
sudo pkg install -y kitty figlet rubygem-lolcat bash curl

# Check if kitty installed
if ! command -v kitty &>/dev/null; then
  echo_color "Error: Kitty installation failed."
  exit 1
fi

# Download kitty.conf
echo_color "Downloading Kitty configuration from GitHub..."
mkdir -p ~/.config/kitty
curl -o ~/.config/kitty/kitty.conf "$GITHUB_REPO/kitty.conf"

# Install Oh My Bash
echo_color "Installing Oh My Bash..."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# Change theme to Kitsune
echo_color "Setting Oh My Bash theme to 'kitsune'..."
sed -i '' 's/OSH_THEME=".*"/OSH_THEME="kitsune"/g' ~/.bashrc

# Add custom welcome banner (only if not already present)
if ! grep -q 'Welcome to Kitty' ~/.bashrc; then
  echo_color "Adding welcome banner to .bashrc..."
  cat <<'EOF' >>~/.bashrc

# Show welcome banner if lolcat and figlet exist
if command -v figlet &> /dev/null && command -v lolcat &> /dev/null; then
    figlet "Welcome to Kitty" | lolcat
fi
EOF
fi

# Final message
echo_color "✅ Setup complete! Restart Kitty or open a new shell to see changes."
