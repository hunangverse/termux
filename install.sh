#!/data/data/com.termux/files/usr/bin/bash
# Installer untuk Termux: cek & pasang ffmpeg + Python + Flask Web UI

set -e

# --------- FUNGSI BANTUAN ---------
check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

check_python_module() {
  python - <<EOF
try:
    import $1
except ImportError:
    raise SystemExit(1)
EOF
}

echo "[*] Update paket Termux..."
pkg update -y && pkg upgrade -y

echo
echo "[*] Validasi dependency paket (ffmpeg, python, git, openssl)..."

# Nama command yang dicek sekaligus nama paket di pkg
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

# Pastikan pip ada
if ! check_cmd pip; then
  echo "  - pip belum ada, mencoba install via python-pip..."
  pkg install -y python-pip || true
fi

# Upgrade pip kalau sudah ada
if check_cmd pip; then
  pip install --upgrade pip
else
  echo "[!] pip masih tidak ditemukan, cek instalasi Python kamu."
fi

# Cek modul flask & waitress
PY_MODS="flask waitress"

for m in $PY_MODS; do
  if check_python_module "$m" 2>/dev/null; then
    echo "  - modul Python '$m' sudah ada, skip."
  else
    echo "  - modul Python '$m' belum ada, install..."
    pip install "$m"
  fi
done

echo
echo "[*] Set permission skrip..."

chmod +x install.sh
chmod +x start_webui.sh
chmod +x stop_webui.sh
chmod +x scripts/start_stream.sh

echo
echo "[✓] Instalasi & validasi dependency selesai."
echo "Jalankan Web UI dengan:"
echo "  ./start_webui.sh"
echo
echo "Lalu buka browser ke:  http://127.0.0.1:8000"