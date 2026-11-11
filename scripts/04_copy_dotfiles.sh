#!/bin/bash

# --- Variables ---
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"  # Remonte à la racine du dépôt
DOTFILES_DIR="$REPO_DIR/dotfiles"

# --- Fonction pour lier un dossier ---
link_dir() {
    local src="$1"
    local dest="$2"
    if [ -d "$src" ]; then
        mkdir -p "$(dirname "$dest")"
        ln -sfn "$src" "$dest" || echo "⚠️ Impossible de lier $src vers $dest"
    else
        echo "⚠️ Dossier source introuvable : $src"
    fi
}

# --- Lier les dossiers de config ---
echo "➡️ Liaison des dotfiles..."

# Kitty
link_dir "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"

# btop
link_dir "$DOTFILES_DIR/btop" "$HOME/.config/btop"

# fastfetch
link_dir "$DOTFILES_DIR/fastfetch" "$HOME/.config/fastfetch"

# niri
link_dir "$DOTFILES_DIR/niri" "$HOME/.config/niri"

# oh-my-zsh (à adapter si tu veux garder le nom "oh-my-zsh_dotfolder")
if [ -d "$DOTFILES_DIR/oh-my-zsh_dotfolder" ]; then
    ln -sfn "$DOTFILES_DIR/oh-my-zsh_dotfolder" "$HOME/.oh-my-zsh" || \
        echo "⚠️ Impossible de lier oh-my-zsh. Vérifiez les permissions."
fi

# Thunar
link_dir "$DOTFILES_DIR/Thunar" "$HOME/.config/Thunar"

# DankMaterialShell
link_dir "$DOTFILES_DIR/DankMaterialShell" "$HOME/.config/DankMaterialShell"

# geany
link_dir "$DOTFILES_DIR/geany" "$HOME/.config/geany"

# BraveSoftware (si c'est pour les profils)
link_dir "$DOTFILES_DIR/BraveSoftware" "$HOME/.config/BraveSoftware"

# autostart
link_dir "$DOTFILES_DIR/autostart" "$HOME/.config/autostart"

echo "✅ Dotfiles liés avec succès !"
