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

# Install modul Flask & Waitress (kalau sudah ada, pip akan skip)
echo "  - memasang modul flask dan waitress (bila belum ada)..."
# --user supaya aman, kalau gagal coba tanpa --user
pip install --user flask waitress 2>/dev/null || pip install flask waitress

echo
echo "[*] Set permission skrip..."

chmod +x install.sh
chmod +x start_webui.sh
chmod +x stop_webui.sh
chmod -R +x scripts

echo
echo "[✓] Instalasi & validasi dependency selesai."
echo "Jalankan Web UI dengan:"
echo "  ./start_webui.sh"
echo
echo "Lalu buka browser ke:  http://127.0.0.1:8000"