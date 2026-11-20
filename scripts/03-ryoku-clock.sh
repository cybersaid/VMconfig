#!/usr/bin/env bash
set -uo pipefail

MODE="dry-run"
[[ "${1:-}" == "--apply" ]] && MODE="apply"

run() {
  if [[ "$MODE" == "apply" ]]; then
    "$@"
  else
    printf 'DRYRUN: %s\n' "$*"
  fi
}

run_root() {
  if [[ "$MODE" == "apply" ]]; then
    sudo "$@"
  else
    printf 'DRYRUN: sudo %s\n' "$*"
  fi
}

write_root_file() {
  local path=$1
  shift

  if [[ "$MODE" == "apply" ]]; then
    printf '%s\n' "$@" | sudo tee "$path" >/dev/null
  else
    printf 'DRYRUN: write (root) %s:\n' "$path"
    printf '%s\n' "$@"
  fi
}

REPO_DIR=/tmp/ryoku
SDDM_DIR="$REPO_DIR/ryoku/lockscreen/sddm"
RYOKU_SHARE=/usr/share/ryoku/lockscreen

echo "== Mode : $MODE =="

echo
echo "== 0. Clone / mise à jour Ryoku =="
if [[ -d "$REPO_DIR/.git" ]]; then
  run git -C "$REPO_DIR" pull --ff-only
else
  run git clone --depth 1 https://github.com/Ryoku-dev/ryoku.git "$REPO_DIR"
fi

echo
echo "== 1. Dépendances Fedora =="
run_root dnf install -y \
  qt6-qtdeclarative \
  qt6-qt5compat \
  qt6-qtsvg \
  qt6-qtmultimedia \
  quickshell \
  sddm

echo
echo "== 2. Dépôt Ryoku =="
run_root install -d -m 0755 /etc/pki/rpm-gpg

run_root curl -fsSL -o /etc/pki/rpm-gpg/RPM-GPG-KEY-ryoku \
  https://repo.ryoku.dev/stable/ryoku-release-key.pub.asc

run gpg --show-keys --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-ryoku

write_root_file /etc/yum.repos.d/ryoku.repo \
'[ryoku]
name=Ryoku
baseurl=https://repo.ryoku.dev/stable/fedora/$releasever/x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ryoku
'

run_root dnf makecache --repo ryoku
run dnf repolist -v | grep -A8 -i ryoku
run dnf list --available 'sddm-theme-ryoku*'
run_root dnf install -y sddm-theme-ryoku

echo
echo "== 3. Remplacement de GDM par SDDM au prochain démarrage =="

if systemctl list-unit-files | grep -q '^gdm\.service'; then
  # IMPORTANT : pas de --now, sinon la session graphique active est tuée.
  run_root systemctl disable gdm.service
else
  echo "GDM n’est pas installé ou n’est pas activé."
fi

run_root systemctl enable sddm.service
run_root systemctl set-default graphical.target 

echo
echo "== 4. Clavier AZERTY =="
run_root localectl set-keymap fr
run_root localectl set-x11-keymap fr

echo
echo "== 5. Wrappers Ryoku =="
run_root install -d -m 0755 "$RYOKU_SHARE"
run_root install -m 0755 \
  "$SDDM_DIR/ryoku-greeter" \
  "$SDDM_DIR/ryoku-wayland-session" \
  "$RYOKU_SHARE/"

echo
echo "== 6. Installation réelle du greeter Ryoku =="
run_root "$SDDM_DIR/setup"
run "$REPO_DIR/ryoku/lockscreen/install-qylock"

echo
echo "== 7. Forçage du clavier AZERTY dans SDDM =="
# Ce fichier est volontairement chargé après 99-ryoku.conf,
# afin que XKB_DEFAULT_LAYOUT=fr ne soit pas écrasé.
write_root_file /etc/sddm.conf.d/99-ryoku-azerty.conf \
'[General]
GreeterEnvironment=QT_QPA_PLATFORM=wayland,XCURSOR_THEME=Bibata-Modern-Ice,XCURSOR_SIZE=24,QML_XHR_ALLOW_FILE_READ=1,XKB_DEFAULT_LAYOUT=fr

[Wayland]
CompositorCommand=/usr/share/ryoku/lockscreen/ryoku-greeter
SessionCommand=/usr/share/ryoku/lockscreen/ryoku-wayland-session
'
echo
echo "==  Activation du verrouilleur Ryoku =="

if systemctl --user list-unit-files | grep -q '^ryoku-shell\.service'; then
  run systemctl --user daemon-reload
  run systemctl --user restart ryoku-shell.service
  run systemctl --user status ryoku-shell --no-pager
else
  echo "ryoku-shell n’est pas encore installé comme service utilisateur."
  echo "Installation du verrouilleur en mode live."
  run env RYOKU_QYLOCK_MODE=live \
    "$REPO_DIR/ryoku/lockscreen/install-qylock"
fi 

echo
echo "== 8. Vérification =="
run systemctl status sddm --no-pager
run systemctl get-default
run cat /etc/sddm.conf.d/99-ryoku-azerty.conf

echo
if [[ "$MODE" == "apply" ]]; then
  echo
  echo "Application terminée."
  echo "Redémarre pour vérifier le nouvel écran de connexion :"
  echo "  sudo systemctl reboot"
else
  echo
  echo "Dry-run terminé : rien n’a été modifié."
  echo "Pour appliquer réellement : ./ryoku-switch-sddm.sh --apply"
fi 
