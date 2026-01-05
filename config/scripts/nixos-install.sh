#!/usr/bin/env bash

# NixOS multi-package installer using fzf --multi (no preview)
# Select multiple packages quickly, then commit & rebuild once.

PACKAGES_FILE="/home/w1dget/nixos/packages.nix"
CONFIG_DIR="$(dirname "$PACKAGES_FILE")"

# Check required tools
for cmd in nix-search-tv fzf git; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd missing. Add to environment.systemPackages."
    exit 1
  fi
done

echo "NixOS Package Installer – Multi-select mode (no preview)"
echo "→ Type to search, Tab or Ctrl+Space to select multiple"
echo "→ Press Enter when done (Esc to cancel)"
echo

# fzf multi-select WITHOUT preview window
selected_lines=$(nix-search-tv print nixpkgs | fzf --multi)

# User cancelled or nothing selected
if [ -z "$selected_lines" ]; then
  echo "No packages selected. Exiting."
  exit 0
fi

# Process selections
mapfile -t lines <<< "$selected_lines"
added_packages=()

# Find closing ]; line once
line_num=$(grep -n '^\s*];$' "$PACKAGES_FILE" | tail -1 | cut -d: -f1)
if [ -z "$line_num" ]; then
  echo "Error: Could not find the closing '];' line in $PACKAGES_FILE"
  exit 1
fi

for line in "${lines[@]}"; do
  selected_raw=$(echo "$line" | awk -F ' │ ' '{print $1}')
  selected=$(echo "$selected_raw" | sed -E 's/^nixpkgs[./]?//')
  [ -z "$selected" ] && selected="$selected_raw"

  # Skip duplicates
  if grep -q "^    $selected$" "$PACKAGES_FILE"; then
    echo "→ Skipping '$selected' (already present)"
    continue
  fi

  # Insert with 4-space indent
  sed -i "${line_num}i     $selected" "$PACKAGES_FILE"

  # Adjust insertion point for next package
  ((line_num++))

  added_packages+=("$selected")
  echo "→ Added '$selected'"
done

# Nothing new added?
if [ ${#added_packages[@]} -eq 0 ]; then
  echo "No new packages added."
  exit 0
fi

echo
echo "Added packages: ${added_packages[*]}"

# Git
echo
echo "Committing changes..."
cd "$CONFIG_DIR" || exit 1
git add "$PACKAGES_FILE"

if [ ${#added_packages[@]} -eq 1 ]; then
  git commit -m "hewo: add ${added_packages[0]}"
else
  git commit -m "hewo: add ${added_packages[*]}"
fi

echo "Pushing..."
git push || echo "Push failed — continuing with rebuild"

# Rebuild
echo
echo "Rebuilding NixOS (flake)..."
sudo nixos-rebuild --flake ~/nixos#nixos-btw --impure switch

if [ $? -eq 0 ]; then
  echo
  echo "Success! Installed: ${added_packages[*]}"
else
  echo
  echo "Rebuild failed — check errors above."
  echo "Git changes are still committed and pushed."
  exit 1
fi
