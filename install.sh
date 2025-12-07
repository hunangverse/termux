#!/data/data/com.termux/files/usr/bin/bash
# Simple installer for Termux: ffmpeg + Python + Flask web UI

set -e

echo "[*] Update paket Termux..."
pkg update -y && pkg upgrade -y

echo "[*] Install dependency: ffmpeg, python, git, openssl..."
pkg install -y ffmpeg python git openssl

echo "[*] Install Python packages (Flask, Waitress)..."
pip install --upgrade pip
pip install flask waitress

# Pastikan permission executable untuk skrip
chmod +x install.sh
chmod +x start_webui.sh
chmod +x stop_webui.sh
chmod +x scripts/start_stream.sh

echo
echo "[✓] Instalasi selesai."
echo "Cara menjalankan Web UI:"
echo "  ./start_webui.sh"
echo
echo "Lalu buka browser di HP kamu ke:  http://127.0.0.1:8000"
echo
echo "Kalau ingin akses dari device lain di jaringan yang sama,"
echo "gunakan IP lokal HP kamu, misalnya: http://192.168.1.5:8000"
