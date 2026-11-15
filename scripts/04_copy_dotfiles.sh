#!/bin/bash

# --- Variables ---
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_DIR="$REPO_DIR/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "➡️ Dépôt détecté : $REPO_DIR"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "❌ Dossier dotfiles introuvable : $DOTFILES_DIR" >&2
    exit 1
fi

copy_dotfile() {
    local src="$1"
    local dest="$2"
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "➡️ Sauvegarde de $dest vers $BACKUP_DIR/"
        mv "$dest" "$BACKUP_DIR/"
    fi
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest" || { echo "❌ Impossible de copier $src → $dest"; return 1; }
    echo "✅ Copié : $src → $dest"
}

# Fichiers racine
for file in .bashrc .zshrc .p10k.zsh .nvidia-settings-rc; do
    [ -f "$DOTFILES_DIR/$file" ] && copy_dotfile "$DOTFILES_DIR/$file" "$HOME/$file"
done

# Dossiers de ~/.config
for dir in kitty niri btop fastfetch geany Thunar DankMaterialShell BraveSoftware autostart; do
    [ -d "$DOTFILES_DIR/$dir" ] && copy_dotfile "$DOTFILES_DIR/$dir" "$HOME/.config/$dir"
done

# oh-my-zsh
if [ -d "$DOTFILES_DIR/oh-my-zsh_dotfolder" ]; then
    copy_dotfile "$DOTFILES_DIR/oh-my-zsh_dotfolder" "$HOME/.oh-my-zsh"
elif [ -d "$DOTFILES_DIR/.oh-my-zsh" ]; then
    copy_dotfile "$DOTFILES_DIR/.oh-my-zsh" "$HOME/.oh-my-zsh"
fi

echo "✅ Dotfiles copiés avec succès !" 
