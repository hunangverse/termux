#!/data/data/com.termux/files/usr/bin/bash

# Simple launcher for the Flask/Waitress web UI

cd "$(dirname "$0")"

# Opsional: cegah HP sleep (kalau termux-wake-lock ada)
if command -v termux-wake-lock >/dev/null 2>&1; then
  termux-wake-lock
fi

echo "[*] Menjalankan Web UI di port 8000..."
# Jalankan sebagai background dengan logging sederhana
PYTHONPATH=. nohup python webui/app.py > webui.log 2>&1 &

echo "[✓] Web UI berjalan (cek di browser: http://127.0.0.1:8000)"
echo "Gunakan 'ps | grep app.py' untuk cek proses,"
echo "atau './stop_webui.sh' untuk mematikannya."
