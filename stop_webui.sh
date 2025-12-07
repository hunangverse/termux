#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Mencari proses webui (app.py)..."

# Kill semua proses python app.py
PIDS=$(ps -o pid,cmd | grep "python webui/app.py" | grep -v grep | awk '{print $1}')

if [ -z "$PIDS" ]; then
  echo "[!] Tidak ada proses webui yang berjalan."
else
  echo "[*] Mematikan PID: $PIDS"
  kill $PIDS || true
  echo "[✓] Web UI dimatikan."
fi

# Lepaskan wake-lock jika ada
if command -v termux-wake-unlock >/dev/null 2>&1; then
  termux-wake-unlock
fi
