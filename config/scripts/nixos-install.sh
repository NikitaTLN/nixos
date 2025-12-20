#!/usr/bin/env bash

# NixOS package installer with fuzzy search (nix-search-tv + fzf)
# Adds package to environment.systemPackages, commits to git, pushes, and rebuilds.
# Perfect for when your NixOS config is in a git repository.

PACKAGES_FILE="/home/w1dget/nixos/packages.nix"  # ← CHANGE THIS if your file is elsewhere (e.g. /home/user/dotfiles/nixos/packages.nix)

# Directory containing your NixOS config (used for git commands)
# Usually the parent directory of PACKAGES_FILE or your git repo root
CONFIG_DIR="$(dirname "$PACKAGES_FILE")"

# Check required tools
for cmd in nix-search-tv fzf git; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd is not installed or not in PATH."
    echo "Ensure 'git', 'fzf', and 'nix-search-tv' are in environment.systemPackages."
    exit 1
  fi
done

echo "Launching fuzzy package search (nix-search-tv + fzf)..."
echo "Start typing to filter, ↑/↓ to navigate, Enter to select, Esc to cancel."
echo

# Fuzzy search with preview
selected_line=$(nix-search-tv print nixpkgs | fzf --preview='nix-search-tv preview {1}' --preview-window=right:70%:wrap)

if [ -z "$selected_line" ]; then
  echo "No package selected. Exiting."
  exit 0
fi

# Extract package name
selected=$(echo "$selected_line" | awk -F ' │ ' '{print $1}')

echo "Selected package: $selected"

# Check for duplicates
if grep -q "^\s\+$selected$" "$PACKAGES_FILE"; then
  echo "'$selected' is already in $PACKAGES_FILE. Nothing to do."
  exit 0
fi

# Find line number of closing "    ];" (4 spaces)
line_num=$(grep -n "^    ];$" "$PACKAGES_FILE" | cut -d: -f1)

if [ -z "$line_num" ]; then
  echo "Error: Could not find the closing '    ];' line in $PACKAGES_FILE"
  echo "Make sure your list uses 4-space indentation before the closing bracket."
  exit 1
fi

# Insert package with 4-space indent
sed -i "${line_num}i    $selected" "$PACKAGES_FILE"

echo "Added '$selected' to $PACKAGES_FILE"

# Git: add, commit, push
echo
echo "Committing changes to git..."
cd "$CONFIG_DIR" || { echo "Failed to cd to $CONFIG_DIR"; exit 1; }

git add "$PACKAGES_FILE"

# You can customize the commit message here if you want something more descriptive
git commit -m "hewo"

echo "Pushing to remote..."
git push origin main

if [ $? -ne 0 ]; then
  echo "Git push failed. You may need to handle it manually."
  echo "Continuing with rebuild anyway..."
fi

# Rebuild the system
echo
echo "Rebuilding NixOS configuration..."
sudo nixos-rebuild --flake ~/nixos#nixos-btw --impure switch

if [ $? -eq 0 ]; then
  echo
  echo "All done! '$selected' has been added, committed, pushed, and installed."
else
  echo
  echo "Rebuild failed. Check the errors above."
  echo "Your git changes are still committed and pushed."
  exit 1
fi
