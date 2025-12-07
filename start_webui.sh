#!/data/data/com.termux/files/usr/bin/bash

# Jalankan Web UI Flask/Waitress

cd "$(dirname "$0")"

# ---------- VALIDASI CEPAT ----------
check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# Cek ffmpeg & python
for cmd in ffmpeg python; do
  if ! check_cmd "$cmd"; then
    echo "[!] Dependency '$cmd' belum terpasang."
    echo "    Jalankan dulu:  bash install.sh"
    exit 1
  fi
done

# Cek modul flask & waitress
python - <<'EOF'
try:
    import flask  # type: ignore
    import waitress  # type: ignore
except Exception:
    raise SystemExit(1)
EOF

if [ $? -ne 0 ]; then
  echo "[!] Modul Python 'flask' atau 'waitress' belum terpasang."
  echo "    Jalankan:  bash install.sh"
  exit 1
fi

# ---------- WAKE LOCK (OPSIONAL) ----------
if command -v termux-wake-lock >/dev/null 2>&1; then
  termux-wake-lock
fi

echo "[*] Menjalankan Web UI di port 8000..."
PYTHONPATH=. nohup python webui/app.py > webui.log 2>&1 &

echo "[✓] Web UI berjalan (cek di browser: http://127.0.0.1:8000)"
echo "Gunakan './stop_webui.sh' untuk mematikannya."