#!/data/data/com.termux/files/usr/bin/bash
# Installer untuk Termux: cek & pasang ffmpeg + Python + Flask Web UI

set -e

check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

echo "[*] Update paket Termux..."
pkg update -y && pkg upgrade -y

echo
echo "[*] Validasi dependency paket (ffmpeg, python, git, openssl)..."

PKGS="ffmpeg python git openssl"

for p in $PKGS; do
  if check_cmd "$p"; then
    echo "  - $p sudah terpasang, skip."
  else
    echo "  - $p belum ada, install $p..."
    pkg install -y "$p"
  fi
done

echo
echo "[*] Validasi dependency Python (pip, flask, waitress)..."

# Pastikan pip ada, tapi TIDAK upgrade pip (sesuai aturan Termux)
if ! check_cmd pip; then
  echo "  - pip belum ada, install paket python-pip..."
  pkg install -y python-pip
else
  echo "  - pip sudah ada, gunakan versi bawaan Termux."
fi

echo "  - memasang modul flask dan waitress (bila belum ada)..."
pip install --user flask waitress 2>/dev/null || pip install flask waitress

echo
echo "[*] Set permission skrip..."

# Semua chmod DIJAGA supaya tidak bikin script mati kalau file belum ada
[ -f "./install.sh" ] && chmod +x install.sh

if [ -f "./start_webui.sh" ]; then
  chmod +x start_webui.sh
  echo "  - start_webui.sh dibuat executable."
else
  echo "  - start_webui.sh belum ada, lewati."
fi

if [ -f "./stop_webui.sh" ]; then
  chmod +x stop_webui.sh
  echo "  - stop_webui.sh dibuat executable."
else
  echo "  - stop_webui.sh belum ada, lewati."
fi

if [ -d "./scripts" ]; then
  chmod -R +x scripts
  echo "  - folder scripts dibuat executable."
else
  echo "  - folder scripts belum ada, lewati."
fi

echo
echo "[✓] Instalasi & validasi dependency selesai."
echo "Kalau start_webui.sh sudah ada, jalankan Web UI dengan:"
echo "  ./start_webui.sh"
echo
echo "Lalu buka browser ke:  http://127.0.0.1:8000"