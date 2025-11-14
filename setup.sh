#!/bin/bash
set -e

echo "Début de la configuration de la session..."

# Installe les paquets RPM
./scripts/01_install_packages.sh

# Installe les applications Flatpak
./scripts/02_install_flatpaks.sh

# Copie les dotfiles
./scripts/03_copy_dotfiles.sh

# Installe les extensions GNOME (si applicable)
./scripts/04_install_gnome_extensions.sh

# Applique les personnalisations (thèmes, polices, etc.)
./scripts/05_final_tweaks.sh

echo "Configuration terminée ! Redémarre ta session pour appliquer tous les changements."
