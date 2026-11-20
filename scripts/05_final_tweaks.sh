#!/bin/bash

# --- Variables ---
CUSTOM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/custom"

# ============================================================
# 1. Polices
# ============================================================
if [ -d "$CUSTOM_DIR/fonts" ]; then
    echo "➡️ Installation des polices..."
    mkdir -p "$HOME/.local/share/fonts"
    cp -r "$CUSTOM_DIR/fonts/"* "$HOME/.local/share/fonts/"
    fc-cache -fv
    echo "✅ Polices installées."
fi

# ============================================================
# 2. Thèmes GTK
# ============================================================
if [ -d "$CUSTOM_DIR/themes" ]; then
    echo "➡️ Installation des thèmes GTK..."
    mkdir -p "$HOME/.themes"
    cp -r "$CUSTOM_DIR/themes/"* "$HOME/.themes/"
    echo "✅ Thèmes GTK installés."
fi

# ============================================================
# 3. Icônes locales (Flat-Remix)
# ============================================================
if [ -d "$CUSTOM_DIR/icons" ]; then
    echo "➡️ Installation des icônes locales..."
    mkdir -p "$HOME/.icons"
    cp -r "$CUSTOM_DIR/icons/"* "$HOME/.icons/"
    echo "✅ Icônes locales installées."
fi

# ============================================================
# 4. Thème d'icônes Adwair (depuis GitHub)
# ============================================================
echo "➡️ Installation du thème d'icônes Adwair..."
ADWAIR_DIR=$(mktemp -d)
if git clone --depth 1 https://github.com/kusaida/Adwair.git "$ADWAIR_DIR"; then
    chmod +x "$ADWAIR_DIR/install.sh -c red"
    "$ADWAIR_DIR/install.sh" || echo "⚠️ L'installation d'Adwair a échoué (ignoré)."
else
    echo "⚠️ Impossible de cloner Adwair (ignoré)."
fi
rm -rf "$ADWAIR_DIR"

# ============================================================
# 5. Application du thème GTK, icônes et police (GNOME)
# ============================================================
echo "➡️ Application du thème GTK et des icônes..."
gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Adwair"
gsettings set org.gnome.desktop.interface font-name "JetBrains Mono 11"

# ============================================================
# 6. Fond d'écran (GNOME + niri/swaybg)
# ============================================================
WALLPAPER_DIR="$CUSTOM_DIR/wallpaper"

# Récupère les images dans un tableau (nullglob : globs sans match = rien)
shopt -s nullglob
IMAGES=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,JPG,JPEG,PNG})
shopt -u nullglob

if [ ${#IMAGES[@]} -gt 0 ]; then
    echo "➡️ Configuration du fond d'écran..."

    # Image choisie : première par ordre alphabétique
    # (décommente la ligne suivante pour une image aléatoire)
    # WALLPAPER="${IMAGES[RANDOM % ${#IMAGES[@]}]}"
    WALLPAPER="${IMAGES[0]}" 
    
    # --- GNOME ---
    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.background picture-uri "file://$BG_DIR/wallpaper-set.jpg"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$BG_DIR/wallpaper-set.jpg" 2>/dev/null
    fi

    # --- Niri (via swaybg) ---
    if command -v niri &>/dev/null; then
        if ! command -v swaybg &>/dev/null; then
            echo "➡️ Installation de swaybg..."
            sudo dnf install -y swaybg
        fi
        NIRI_CONFIG="$HOME/.config/niri/config.kdl"
        if [ -f "$NIRI_CONFIG" ] && ! grep -q "swaybg" "$NIRI_CONFIG"; then
            cat >> "$NIRI_CONFIG" << EOF

// Fond d'écran (ajouté par 05_final_tweaks.sh)
spawn-at-startup "swaybg" -m fill -i "$BG_DIR/wallpaper-set.jpg"
EOF
            echo "✅ swaybg ajouté à la config niri"
        elif [ ! -f "$NIRI_CONFIG" ]; then
            echo "⚠️ Config niri introuvable : $NIRI_CONFIG"
        else
            echo "ℹ️ swaybg déjà présent dans la config niri"
        fi
    fi

    echo "✅ Fond d'écran appliqué : $WALLPAPER"
else
    echo "⚠️ Aucune image trouvée dans $WALLPAPER_DIR (ignoré)."
fi

# ============================================================
# 7. Partage des thèmes/icônes avec les Flatpaks
# ============================================================
if command -v flatpak &>/dev/null; then
    echo "➡️ Partage des icônes avec les Flatpaks..."
    sudo flatpak override --filesystem=~/.local/share/icons
    sudo flatpak override --filesystem=~/.themes
fi

# ============================================================
# 8. Changement du gestionnaire de session
# ============================================================
sudo dnf install -y sddm
# 2. Désactiver GDM, activer SDDM
sudo systemctl disable gdm
sudo systemctl enable sddm 

echo "✅ Tous les tweaks ont été appliqués avec succès !"
