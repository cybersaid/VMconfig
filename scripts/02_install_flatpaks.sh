#!/bin/bash

# Vérifier que flatpak est installé
if ! command -v flatpak &> /dev/null; then
    echo "❌ flatpak n'est pas installé. Installation en cours..."
    sudo dnf install -y flatpak || {
        echo "❌ Impossible d'installer flatpak."
        exit 1
    }
fi

# Ajouter Flathub si ce n'est pas déjà fait
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Installer les Flatpaks
echo "➡️ Installation des Flatpaks..."
flatpak install -y flathub \
    app.drey.Dialect \
    com.mattjakeman.ExtensionManager \
    com.valvesoftware.Steam \
    com.valvesoftware.Steam.CompatibilityTool.Proton \
    md.obsidian.Obsidian \
    io.github.congard.qnvsm \
    net.zdechov.app.x2048 \
    org.gtk.Gtk3theme.Flat-Remix-GTK-Blue-Dark \
    org.kde.WaylandDecoration.QAdwaitaDecorations \
    org.localsend.localsend_app \
    org.onlyoffice.desktopeditors \
    com.brave.Browser

echo "✅ Flatpaks installés avec succès !"
