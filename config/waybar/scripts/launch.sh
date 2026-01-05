#!/usr/bin/env bash

# Available themes: alchemy, subtle, ultra_minimal, velvetline

waybar_config_dir="/home/$USER/.config/waybar"
pkill -9 .waybar-wrapped
pkill -9 .swaync-wrapped

swaync &

waybar &
