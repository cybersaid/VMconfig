>#!/bin/bash
set -e

echo "Début de l'installation..."
./scripts/01_install_packages.sh
./scripts/02_install_flatpaks.sh
./scripts/03_copy_dotfiles.sh
./scripts/04_install_gnome_extensions.sh
./scripts/05_final_tweaks.sh

echo "Installation terminée !"

