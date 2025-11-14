#!/bin/bash
extensions=(
    "dash-to-dock@micxgx.gmail.com"
    "blur-my-shell@aunetx"
    "monitor@astraext.github.io"
    "apps-menu@gnome-shell-extensions.gcampax.github.com"
    "background-logo@fedorahosted.org"
    "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
    "places-menu@gnome-shell-extensions.gcampax.github.com"
    "window-list@gnome-shell-extensions.gcampax.github.com"
)
for ext in \"${extensions[@]}\"; do
    gnome-extensions install \"$ext\"
done
gnome-extensions enable \"${extensions[@]}\"
