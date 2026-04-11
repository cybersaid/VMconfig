# Fedora Setup Automation

**Automatise l'installation et la configuration de ton environnement Fedora en quelques minutes !**

---

## 📌 Description
Ce dépôt contient des **scripts Bash** et des **dotfiles** pour configurer automatiquement une nouvelle installation Fedora selon tes préférences :
- Installation des **paquets RPM** (via `dnf`).
- Installation des **Flatpaks**.
- Configuration des **extensions GNOME**.
- Copie des **dotfiles** (kitty, zsh, niri, etc.).
- Application des **thèmes, polices et fonds d'écran**.
- **Tweaks finaux** (permissions, services, etc.).

---

## 📦 Structure du projet

VMconfig/

├── custom/               # Thèmes, polices, icônes, fonds d'écran et wallpapers

│   ├── fonts/

│   ├── icons/

│   ├── themes/

│   └── wallpaper/

├── dotfiles/             # Fichiers de configuration (dotfiles)

│   ├── kitty/

│   ├── niri/

│   ├── oh-my-zsh_dotfolder/

│   └── ...

├── scripts/              # Scripts d'installation

│   ├── 01_install_packages.sh   # Paquets RPM (dnf)

│   ├── 02_install_flatpaks.sh    # Flatpaks

│   ├── 03_install_gnome_extensions.sh

│   ├── 04_copy_dotfiles.sh       # Copie/lien des dotfiles

│   └── 05_final_tweaks.sh       # Tweaks finaux

├── setup.sh              # Script principal

└── README.md

---

## ⚙️ Prérequis
- **Fedora 38+** (testé sur Fedora 40).
- **Connexion internet** (pour télécharger les paquets).
- **Git** installé (sinon : `sudo dnf install -y git`).
- **Droits root** (pour installer les paquets).

---

## 🚀 Installation
*Pour éviter les problème potentiels, il est préférable de mettre à jour avant de lancer le script*
### 1. Cloner le dépôt
```bash
git clone https://github.com/cybersaid/VMconfig.git ~/VMconfig
cd ~/VMconfig
```
###2. Donner les permissions d'exécution
```bash
chmod +x setup.sh scripts/*.sh
```
###3. Lancer l'installation

```bash
./setup.sh
```


###4. Redémarrer la session
Certains changements (comme les thèmes où les services) nécessitent un redémarrage.

