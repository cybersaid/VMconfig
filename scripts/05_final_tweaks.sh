#!/bin/bash
CUSTOM_DIR="$(pwd)/custom"

# Installe les polices
if [ -d "$CUSTOM_DIR/fonts" ]; then
    mkdir -p "$HOME/.local/share/fonts"
    cp -r "$CUSTOM_DIR/fonts/"* "$HOME/.local/share/fonts/"
    fc-cache -fv
    echo "Fonts installed and cache updated."
fi

# Installe les thèmes GTK
if [ -d "$CUSTOM_DIR/themes" ]; then
    mkdir -p "$HOME/.themes"
    cp -r "$CUSTOM_DIR/themes/"* "$HOME/.themes/"
    echo "GTK themes installed."
fi

# Installe les icônes
if [ -d "$CUSTOM_DIR/icons" ]; then
    mkdir -p "$HOME/.icons"
    cp -r "$CUSTOM_DIR/icons/"* "$HOME/.icons/"
    echo "Icons installed."
fi

# Applique le thème et les icônes (pour GNOME)
gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-GTK-Blue-Dark"
gsettings set org.gnome.desktop.interface font-name "JetBrains Mono 11"

# Configure le fond d'écran
if [ -d "$CUSTOM_DIR/wallpapers" ]; then
    gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.local/share/backgrounds/my-wallpaper.jpg"
    cp -r "$CUSTOM_DIR/wallpapers/"* "$HOME/.local/share/backgrounds/"
    echo "Wallpapers installed."
fi

echo "All tweaks applied successfully!"
