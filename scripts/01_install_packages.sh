#!/bin/bash

# --- Activation de RPM Fusion (Free et Non-Free) ---
echo "➡️ Activation de RPM Fusion..."
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# --- Ajout du dépôt COPR pour Niri ---
echo "➡️ Ajout du dépôt COPR pour Niri..."
sudo dnf copr enable avengemedia/dms
sudo dnf copr enable yalter/niri

# --- Mise à jour de dnf ---
echo "➡️ Mise à jour de dnf..."
sudo dnf update -y

# --- Installation des paquets RPM ---
echo "➡️ Installation des paquets RPM..."
# --- Liste des paquets à installer (séparés en groupes logiques) ---
PAQUETS_UTILITAIRES=(
    7zip
    blueman
    cava
    cliphist
    corectrl
    abrt
    abrt-addon-ccpp
    abrt-addon-xorg
)

PAQUETS_TERMINAL=(
    kitty
    zsh
)

PAQUETS_EDITION=(
    geany
)

PAQUETS_MONITORING=(
    btop
    fastfetch
)

PAQUETS_RESEAU=(
    aardvark-dns
)

PAQUETS_FONTES=(
    # Remplacement de aajohan-comfortaa-fonts (inexistant)
    comfortaa-fonts
    fontconfig
)

PAQUETS_DEPENDANCES=(
    git
    curl
    wget
    make
    gcc
    pkgconf
    meson
    cmake
)

# --- Fonction pour installer un groupe de paquets (ignore les erreurs individuelles) ---
install_paquets() {
    local nom_groupe="$1"
    shift
    local paquets=("$@")
    echo "➡️ Installation des paquets $nom_groupe..."
    sudo dnf install -y "${paquets[@]}" || {
        echo "⚠️ Certains paquets $nom_groupe n'ont pas pu être installés (ignoré)."
    }
}

# --- Installation des paquets ---
install_paquets "utilitaires" "${PAQUETS_UTILITAIRES[@]}"
install_paquets "terminal" "${PAQUETS_TERMINAL[@]}"
install_paquets "édition" "${PAQUETS_EDITION[@]}"
install_paquets "monitoring" "${PAQUETS_MONITORING[@]}"
install_paquets "réseau" "${PAQUETS_RESEAU[@]}"
install_paquets "polices" "${PAQUETS_FONTES[@]}"
install_paquets "dépendances" "${PAQUETS_DEPENDANCES[@]}"

# --- Installation de Niri (via COPR) ---
echo "➡️ Installation de Niri..."
sudo dnf install -y niri || {
    echo "⚠️ Niri n'a pas pu être installé. Vérifiez le dépôt COPR."
}

echo "✅ Installation des paquets terminée (certains peuvent avoir été ignorés)."




