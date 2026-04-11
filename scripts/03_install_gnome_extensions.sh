#!/bin/bash

# --- Variables ---
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"  # Racine du dépôt
DOTFILES_DIR="$REPO_DIR/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# --- Fonction pour lier un fichier/dossier ---
link_dotfile() {
    local src="$1"
    local dest="$2"
    if [ -e "$dest" ]; then
        echo "➡️ Sauvegarde de $dest vers $BACKUP_DIR/"
        mv "$dest" "$BACKUP_DIR/"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest" || {
        echo "❌ Impossible de lier $src vers $dest"
        return 1
    }
    echo "✅ Lié : $src → $dest"
}

# --- Lier les fichiers racine (si ils existent) ---
for file in .bashrc .zshrc .p10k.zsh .nvidia-settings-rc; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        link_dotfile "$DOTFILES_DIR/$file" "$HOME/$file"
    fi
done

# --- Lier les dossiers de ~/.config ---
for dir in kitty niri btop fastfetch geany Thunar DankMaterialShell BraveSoftware autostart; do
    if [ -d "$DOTFILES_DIR/$dir" ]; then
        link_dotfile "$DOTFILES_DIR/$dir" "$HOME/.config/$dir"
    fi
done

# --- Lier oh-my-zsh (avec renommage si nécessaire) ---
if [ -d "$DOTFILES_DIR/oh-my-zsh_dotfolder" ]; then
    link_dotfile "$DOTFILES_DIR/oh-my-zsh_dotfolder" "$HOME/.oh-my-zsh"
elif [ -d "$DOTFILES_DIR/.oh-my-zsh" ]; then
    link_dotfile "$DOTFILES_DIR/.oh-my-zsh" "$HOME/.oh-my-zsh"
fi

echo "✅ Dotfiles liés avec succès !"
