#!/data/data/com.termux/files/usr/bin/bash

# scripts/start_stream.sh
# Argumen:
#   $1 = INPUT (file path atau URL)
#   $2 = RTMP_URL (tujuan streaming)
#   $3 = VIDEO_BITRATE (mis. 2000k)
#   $4 = AUDIO_BITRATE (mis. 128k)

INPUT="$1"
RTMP_URL="$2"
VIDEO_BITRATE="${3:-2000k}"
AUDIO_BITRATE="${4:-128k}"

if [ -z "$INPUT" ] || [ -z "$RTMP_URL" ]; then
  echo "Usage: $0 <input> <rtmp_url> [video_bitrate] [audio_bitrate]"
  exit 1
fi

# Outputkan info
echo "[*] Start streaming..."
echo "    Input       : $INPUT"
echo "    RTMP target : $RTMP_URL"
echo "    Video bitrate: $VIDEO_BITRATE"
echo "    Audio bitrate: $AUDIO_BITRATE"

# Jalankan ffmpeg
# -re = realtime read, cocok untuk file / network input
# -c:v libx264 & -preset veryfast = codec umum untuk live
# -f flv = format untuk RTMP
ffmpeg -re -i "$INPUT" \
  -c:v libx264 -preset veryfast -b:v "$VIDEO_BITRATE" \
  -c:a aac -b:a "$AUDIO_BITRATE" \
  -f flv "$RTMP_URL"
