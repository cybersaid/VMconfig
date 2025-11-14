#!/bin/bash
DOTFILES_DIR="$(pwd)/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d)"

# Crée un dossier de sauvegarde
mkdir -p "$BACKUP_DIR"

# Fonction pour créer un lien symbolique ou sauvegarder l'ancien fichier
link_dotfile() {
    local src="$1"
    local dest="$2"
    if [ -e "$dest" ]; then
        echo "Backup $dest to $BACKUP_DIR/"
        mv "$dest" "$BACKUP_DIR/"
    fi
    cp -r "$src" "$dest"
    echo "Copied $src to $dest"
}

# Copie les fichiers racine
for file in "$DOTFILES_DIR"/.{bashrc,zshrc,p10k.zsh,nvidia-settings-rc}; do
    if [ -f "$file" ]; then
        link_dotfile "$file" "$HOME/$(basename "$file")"
    fi
done

# Copie le dossier .config/ et ses sous-dossiers
if [ -d "$DOTFILES_DIR/.config" ]; then
    for config in $(ls -A "$DOTFILES_DIR/.config"); do
        link_dotfile "$DOTFILES_DIR/.config/$config" "$HOME/.config/$config"
    done
fi

echo "Dotfiles copied successfully!"
