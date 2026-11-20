#!/bin/bash

# --- Variables ---
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
SKIP_FLATPAK=false

# --- Gestion des options ---
for arg in "$@"; do
    case "$arg" in
        --no-flatpak|-nf)
            SKIP_FLATPAK=true
            echo "⏭️  Option activée : les Flatpaks seront ignorés."
            ;;
        --help|-h)
            echo "Usage : ./setup.sh [OPTIONS]"
            echo "  --no-flatpak, -nf   Ignore l'installation des Flatpaks (étape 02)"
            echo "  --help, -h          Affiche cette aide"
            exit 0
            ;;
        *)
            echo "❌ Option inconnue : $arg (voir ./setup.sh --help)" >&2
            exit 1
            ;;
    esac
done

# --- Fonctions ---
error_exit() {
    echo "❌ Erreur : $1" >&2
    exit 1
}

backup_existing() {
    echo "➡️ Sauvegarde des fichiers existants dans $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"

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

run_script "$REPO_DIR/scripts/01_install_packages.sh"

if [ "$SKIP_FLATPAK" = false ]; then
    run_script "$REPO_DIR/scripts/02_install_flatpaks.sh"
else
    echo "⏭️  Étape 02 (Flatpaks) ignorée."
fi

run_script "$REPO_DIR/scripts/03_ryoku_clock.sh"
run_script "$REPO_DIR/scripts/04_copy_dotfiles.sh"
run_script "$REPO_DIR/scripts/05_final_tweaks.sh"

echo "✅ Installation terminée ! Redémarrez votre session pour appliquer les changements."
