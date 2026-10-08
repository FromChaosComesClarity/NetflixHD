#!/bin/bash

# Install NetflixHD for this user: the launcher, its icon and its menu entry.
# Nothing system-wide, no password.
#
#   ./install.sh              install or update
#   ./install.sh --uninstall  remove the launcher, icon and menu entry
#                             (keeps the Netflix profile: login, settings)
#   ./install.sh --purge      remove all of it, the profile too

set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
data="${XDG_DATA_HOME:-$HOME/.local/share}"
bin_dest="$HOME/.local/bin/netflixhd"
icon_dest="$data/icons/hicolor/scalable/apps/netflixhd.svg"
entry_dest="$data/applications/netflixhd.desktop"
profile="$data/netflixhd"

refresh_menu() {
  command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$data/applications" || true
}

case "${1:-}" in
  --uninstall | --purge)
    rm -f "$bin_dest" "$icon_dest" "$entry_dest"
    rm -rf "$profile/extension"
    refresh_menu
    if [[ $1 == --purge ]]; then
      rm -rf "$profile"
      echo "NetflixHD removed, profile too."
    else
      echo "NetflixHD removed. The profile (login, settings) is kept in $profile."
    fi
    exit 0
    ;;
  "" ) ;;
  * ) echo "usage: $0 [--uninstall | --purge]" >&2; exit 2 ;;
esac

install -Dm755 "$here/bin/netflixhd" "$bin_dest"
install -Dm644 "$here/assets/netflixhd.svg" "$icon_dest"
rm -rf "$profile/extension"
install -d "$profile/extension"
install -m644 "$here"/extension/* "$profile/extension/"
mkdir -p "$(dirname "$entry_dest")"

# Absolute paths: a menu entry cannot count on ~/.local/bin being on the
# session's PATH, and the icon should not depend on an icon-cache refresh.
cat >"$entry_dest" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=NetflixHD
GenericName=Netflix on the TV
Comment=Netflix in a frameless full-screen window, for the TV.
Exec=$bin_dest
Icon=$icon_dest
Terminal=false
Categories=AudioVideo;Video;
Keywords=netflix;tv;movies;series;films;streaming;
StartupWMClass=NetflixHD
EOF

refresh_menu
echo "NetflixHD installed: $bin_dest"
echo "It is in the system menu now; in OMATVLauncher, add it with Add app."
