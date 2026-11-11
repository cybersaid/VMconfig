#!/bin/bash

# --- Variables ---
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # Chemin absolu du dépôt
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"  # Dossier de backup

# --- Fonctions ---
error_exit() {
    echo "❌ Erreur : $1" >&2
    exit 1
}

backup_existing() {
    echo "➡️ Sauvegarde des fichiers existants dans $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"

    # Liste des fichiers/dossiers à sauvegarder (à adapter)
    local files_to_backup=(
        "$HOME/.config/kitty"
        "$HOME/.config/btop"
        "$HOME/.config/fastfetch"
        "$HOME/.config/niri"
        "$HOME/.zshrc"
        "$HOME/.oh-my-zsh"
    )

    for file in "${files_to_backup[@]}"; do
        if [ -e "$file" ]; then
            mv "$file" "$BACKUP_DIR/" || error_exit "Impossible de sauvegarder $file"
        fi
    done
}

check_dependencies() {
    echo "➡️ Vérification des dépendances de base..."
    local deps=("git" "curl" "ln" "mkdir" "chmod")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            error_exit "$dep n'est pas installé. Installez-le avec 'sudo dnf install -y $dep'"
        fi
    done
}

run_script() {
    local script="$1"
    echo "➡️ Exécution de $script..."
    if [ -f "$script" ]; then
        chmod +x "$script"
        "$script" || error_exit "Le script $script a échoué"
    else
        error_exit "Script introuvable : $script"
    fi
}

# --- Exécution ---
check_dependencies
backup_existing

# Exécuter les scripts dans l'ordre
run_script "$REPO_DIR/scripts/01_install_packages.sh"
run_script "$REPO_DIR/scripts/02_install_flatpaks.sh"
run_script "$REPO_DIR/scripts/04_copy_dotfiles.sh"
run_script "$REPO_DIR/scripts/05_final_tweaks.sh"

echo "✅ Installation terminée ! Redémarrez votre session pour appliquer les changements."
