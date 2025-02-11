#!/bin/bash

CONFIG="$HOME/.config/hypr/hyprlock.conf"
WALLPAPER=$(swww query | grep -oP '(?<=image: ).*')

# Ensure wallpaper path is found
if [ -f "$WALLPAPER" ]; then
    # Update the Hyprlock config file
    sed -i "s|path = .*|path = $WALLPAPER|" "$CONFIG"
else
    echo "Wallpaper file not found: $WALLPAPER"
    exit 1
fi

# Start Hyprlock
hyprlock
