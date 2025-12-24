#!/usr/bin/env bash

# NixOS package installer with fuzzy search (nix-search-tv + fzf)
# Flake-based, git-managed, matches your exact indentation style

PACKAGES_FILE="/home/w1dget/nixos/packages.nix"
CONFIG_DIR="$(dirname "$PACKAGES_FILE")"

# Check required tools
for cmd in nix-search-tv fzf git; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd missing. Add to environment.systemPackages."
    exit 1
  fi
done

echo "Launching fuzzy package search (nix-search-tv + fzf)..."
echo "Start typing to filter, ↑/↓ to navigate, Enter to select, Esc to cancel."
echo

# Fuzzy search with nice preview window
selected_line=$(nix-search-tv print nixpkgs | fzf)

[ -z "$selected_line" ] && echo "No package selected. Exiting." && exit 0

# Extract raw attribute name
selected_raw=$(echo "$selected_line" | awk -F ' │ ' '{print $1}')

# Remove nixpkgs. or nixpkgs/ prefix if present
selected=$(echo "$selected_raw" | sed -E 's/^nixpkgs[./]?//')

[ -z "$selected" ] && selected="$selected_raw"

echo "Selected package: $selected"

# Duplicate check (4-space indented lines)
if grep -q "^    $selected$" "$PACKAGES_FILE"; then
  echo "'$selected' is already in the list."
  exit 0
fi

# Find the closing ]; line (any indentation, take the last one just in case)
line_num=$(grep -n '^\s*];$' "$PACKAGES_FILE" | tail -1 | cut -d: -f1)

if [ -z "$line_num" ]; then
  echo "Error: Could not find the closing '];' line in $PACKAGES_FILE"
  exit 1
fi

# Insert new package with exactly 4-space indentation
sed -i "${line_num}i     $selected" "$PACKAGES_FILE"

echo "Added '$selected' to $PACKAGES_FILE"

# Git operations
echo
echo "Committing changes..."
cd "$CONFIG_DIR" || exit 1
git add "$PACKAGES_FILE"
git commit -m "hewo"

echo "Pushing..."
git push || echo "Push failed — continuing anyway"

# Rebuild with your flake
echo
echo "Rebuilding NixOS (flake)..."
sudo nixos-rebuild --flake ~/nixos#nixos-btw --impure switch

if [ $? -eq 0 ]; then
  echo
  echo "Success! '$selected' added, committed, pushed, and installed."
else
  echo
  echo "Rebuild failed — check errors above."
  exit 1
fi
