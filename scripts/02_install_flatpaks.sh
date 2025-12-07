#!/bin/bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
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
    org.onlyoffice.desktopeditors

