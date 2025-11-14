# Fedora Setup Automation

**Automatise l'installation et la configuration de ton environnement Fedora en quelques minutes !**

---

## 📌 Description

Ce dépôt contient des **scripts Bash** et des **dotfiles** pour configurer automatiquement une nouvelle installation Fedora selon tes préférences. Il installe tes applications, copie tes configurations, applique tes thèmes, polices et extensions GNOME, et bien plus encore.

---

## 📦 Structure du projet

VMconfig/
├── custom/               # Thèmes, polices et fonds d'écran personnalisés
├── dotfiles/             # Fichiers de configuration (dotfiles)
├── scripts/              # Scripts d'installation et de configuration
│   ├── 01_install_packages.sh
│   ├── 02_install_flatpaks.sh
│   ├── 03_install_gnome_extensions.sh
│   ├── 04_copy_dotfiles.sh
│   └── 05_final_tweaks.sh
├── setup.sh              # Script principal pour lancer l'installation
└── README.md             # Ce fichier

---

## 🚀 Utilisation

### 1. Cloner le dépôt
```bash
git clone https://github.com/cybersaid/VMconfig.git
cd VMconfig
chmod +x setup.sh
./setup.sh
```