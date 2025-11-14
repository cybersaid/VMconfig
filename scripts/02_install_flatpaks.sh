#!/bin/bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub \
    app.drey.Dialect \
    com.mattjakeman.ExtensionManager \
    com.valvesoftware.Steam \
    io.github.congard.qnvsm \
    net.zdechov.app.x2048 \
    org.gtk.Gtk3theme.Flat-Remix-GTK-Blue-Dark \
    org.kde.WaylandDecoration.QAdwaitaDecorations \
    com.sublimetext.three \
    org.localsend.localsend_app
