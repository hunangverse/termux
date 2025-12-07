#!/data/data/com.termux/files/usr/bin/bash
# Bootstrap installer: clone app & jalankan installer di dalamnya

set -e

REPO_URL="https://github.com/hunangverse/termux-ffmpeg-live-webui.git"
APP_DIR="$HOME/termux-ffmpeg-live-webui"

echo "[*] Update pkg & install git..."
pkg update -y && pkg upgrade -y
pkg install -y git

echo
echo "[*] Clone / update repo aplikasi..."

if [ -d "$APP_DIR" ]; then
  echo "  - Repo sudah ada, pull update..."
  cd "$APP_DIR"
  git pull
else
  echo "  - Repo belum ada, clone baru..."
  git clone "$REPO_URL" "$APP_DIR"
  cd "$APP_DIR"
fi

echo
echo "[*] Jalankan installer aplikasi (dependency + permission)..."
bash install.sh

echo
echo "[✓] Semua selesai."
echo "Untuk menjalankan Web UI:"
echo "  cd $APP_DIR && ./start_webui.sh"