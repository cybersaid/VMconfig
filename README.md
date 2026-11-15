# Fedora Setup Automation

**Automatise l'installation et la configuration de ton environnement Fedora en quelques minutes !**

---

## 📌 Description
Ce dépôt contient des **scripts Bash** et des **dotfiles** pour configurer automatiquement une nouvelle installation Fedora selon tes préférences :
- Activation des **dépôts tiers** (RPM Fusion, COPR) et installation des **paquets RPM** (via `dnf`).
- Installation des **Flatpaks** (via Flathub).
- **Copie des dotfiles** (kitty, zsh, niri, btop, fastfetch, etc.) — de vraies copies, pas des liens, pour pouvoir personnaliser sur la machine sans impacter le dépôt.
- Installation du **thème d'icônes Adwair** et application des **thèmes, polices et fond d'écran**.
- **Tweaks finaux** (dnf parallèle, partage des thèmes avec les Flatpaks, etc.).

---

## 📦 Structure du projet

```
VMconfig/
├── custom/                      # Thèmes, polices, icônes et wallpapers
│   ├── fonts/                   #   JetBrains Mono, Fantasque, MesloLGS, Victor Mono...
│   ├── icons/                   #   Flat-Remix Blue Dark/Light
│   ├── themes/                  #   Flat-Remix-GTK Blue Dark/Light
│   └── wallpaper/               #   Fonds d'écran
├── dotfiles/                    # Fichiers de configuration (copiés vers $HOME)
│   ├── kitty/
│   ├── niri/
│   ├── .oh-my-zsh/
│   ├── .zshrc
│   └── ...
├── scripts/                     # Scripts d'installation (exécutés dans l'ordre)
│   ├── 01_install_packages.sh   # Dépôts tiers + paquets RPM (dnf)
│   ├── 02_install_flatpaks.sh   # Flatpaks + Flathub
│   ├── 04_copy_dotfiles.sh      # Copie des dotfiles (avec backup)
│   └── 05_final_tweaks.sh       # Thèmes, polices, wallpaper, tweaks
├── setup.sh                     # Script principal
└── README.md
```

---

## ⚙️ Prérequis
- **Fedora 38+** (testé sur Fedora 40).
- **Connexion internet** (pour télécharger les paquets).
- **Git** installé (sinon : `sudo dnf install -y git`).
- **Droits sudo** (pour installer les paquets).
- Un **environnement niri** ou **GNOME** pour la partie thèmes/wallpaper.

---

## 🚀 Installation
*Pour éviter les problèmes potentiels, il est préférable de mettre à jour avant de lancer le script.*

### 1. Cloner le dépôt
```bash
git clone https://github.com/cybersaid/VMconfig.git ~/VMconfig
cd ~/VMconfig
```

### 2. Donner les permissions d'exécution
```bash
chmod +x setup.sh scripts/*.sh
```

### 3. Lancer l'installation
```bash
# Installation complète
./setup.sh

# Installation sans les Flatpaks (utile pour tester rapidement)
./setup.sh --no-flatpak

# Afficher l'aide
./setup.sh --help
```

### 4. Redémarrer la session
Certains changements (thèmes, wallpaper, services) nécessitent un redémarrage de la session.

---

## 🔧 Ce que fait le script en détail

| Étape | Script | Contenu |
|-------|--------|---------|
| 01 | `01_install_packages.sh` | Active RPM Fusion et les dépôts COPR (niri, dms), active les téléchargements dnf parallèles (`max_parallel_downloads`, `fastestmirror`), installe les paquets par groupes (utilitaires, terminal, édition, monitoring, polices, dépendances) puis niri. |
| 02 | `02_install_flatpaks.sh` | Installe Flatpak si absent, ajoute Flathub, active les téléchargements parallèles, installe les applications (Steam, Obsidian, OnlyOffice, LocalSend, Dialect, Extension Manager, thème GTK Flat-Remix...). |
| 04 | `04_copy_dotfiles.sh` | **Sauvegarde** les configs existantes dans `~/dotfiles_backup_<date>` puis **copie** les dotfiles vers `$HOME` et `~/.config/`. |
| 05 | `05_final_tweaks.sh` | Installe les polices (`fc-cache`), les thèmes GTK et icônes locaux, le thème d'icônes **Adwair** (depuis GitHub), applique le thème GTK/icônes/police via `gsettings`, configure le fond d'écran (GNOME + `swaybg` pour niri), et partage les thèmes avec les Flatpaks (`flatpak override`). |

---

## 🔄 Personnaliser et versionner

Les dotfiles sont **copiés** (pas de liens symboliques) : tu peux modifier tes configs sur la machine sans impacter le dépôt. Pour remonter une modification vers le dépôt :

```bash
cp -r ~/.config/kitty/* ~/VMconfig/dotfiles/kitty/
cd ~/VMconfig
git add dotfiles
git commit -m "Update kitty config depuis la VM"
git push
```

---

## ⚠️ Notes
- Un **backup** de tes anciennes configs est créé dans `~/dotfiles_backup_<date>` à chaque exécution.
- Les installations de paquets **tolèrent les échecs individuels** (un paquet manquant n'arrête pas tout).
- Le script est **idempotent** : les réglages dnf et la config wallpaper ne sont pas dupliqués si tu relances `setup.sh`.
