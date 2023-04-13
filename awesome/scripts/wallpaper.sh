#!/usr/bin/env bash

# Set the directory containing your wallpaper images
WALLPAPER_DIR="$HOME/.config/awesome/wallpapers"

# Set the total number of wallpaper images in your collection
NUM_WALLPAPERS=24

while true; do
    # Get the current hour in 24-hour format
    HOUR=$(date +%H | sed 's/^0//')

    # Calculate the index of the next wallpaper image
    NEXT_WALLPAPER=$((HOUR % NUM_WALLPAPERS))

    # Set the path to the next wallpaper image
    WALLPAPER_PATH="$WALLPAPER_DIR/Catalina-$NEXT_WALLPAPER.jpg"

    # Set the wallpaper using feh
    feh --bg-fill "$WALLPAPER_PATH"

    # Wait for an hour before updating the wallpaper again
    sleep 3600
done
