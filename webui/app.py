import os
import signal
import subprocess
from flask import Flask, render_template, request, redirect, url_for, jsonify

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPTS_DIR = os.path.join(BASE_DIR, "scripts")
STREAM_PID_FILE = os.path.join(BASE_DIR, "stream.pid")


def is_streaming():
    """Cek apakah ada proses streaming yang masih hidup."""
    if not os.path.exists(STREAM_PID_FILE):
        return False

    try:
        with open(STREAM_PID_FILE, "r") as f:
            pid = int(f.read().strip())
        # cek proses masih hidup
        os.kill(pid, 0)
        return True
    except (ValueError, ProcessLookupError, ProcessLookupError, OSError):
        # PID file invalid atau proses sudah mati
        return False


def stop_stream():
    """Hentikan proses streaming jika ada."""
    if not os.path.exists(STREAM_PID_FILE):
        return False

    try:
        with open(STREAM_PID_FILE, "r") as f:
            pid = int(f.read().strip())

        # SIGTERM dulu
        os.kill(pid, signal.SIGTERM)
    except Exception:
        pass
    finally:
        if os.path.exists(STREAM_PID_FILE):
            os.remove(STREAM_PID_FILE)
    return True


@app.route("/", methods=["GET"])
def index():
    status = "ON" if is_streaming() else "OFF"
    return render_template("index.html", status=status)


@app.route("/start", methods=["POST"])
def start():
    input_source = request.form.get("input_source", "").strip()
    rtmp_url = request.form.get("rtmp_url", "").strip()
    v_bitrate = request.form.get("video_bitrate", "2000k").strip()
    a_bitrate = request.form.get("audio_bitrate", "128k").strip()

    if not input_source or not rtmp_url:
        return redirect(url_for("index"))

    # Kalau sedang streaming, hentikan dulu
    if is_streaming():
        stop_stream()

    script_path = os.path.join(SCRIPTS_DIR, "start_stream.sh")

    # Jalankan ffmpeg via script sebagai background
    proc = subprocess.Popen(
        [script_path, input_source, rtmp_url, v_bitrate, a_bitrate],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

    # Simpan PID
    with open(STREAM_PID_FILE, "w") as f:
        f.write(str(proc.pid))

    return redirect(url_for("index"))


@app.route("/stop", methods=["POST"])
def stop():
    stop_stream()
    return redirect(url_for("index"))


@app.route("/status", methods=["GET"])
def status():
    return jsonify({"streaming": is_streaming()})


if __name__ == "__main__":
    # Jalankan dengan Flask dev server atau Waitress
    # Disarankan: gunakan Waitress untuk lebih stabil
    try:
        from waitress import serve

        port = int(os.environ.get("PORT", 8000))
        print(f"[*] Running with Waitress on port {port}...")
        serve(app, host="0.0.0.0", port=port)
    except ImportError:
        print("[!] Waitress tidak terinstall, fallback ke Flask dev server.")
        app.run(host="0.0.0.0", port=8000, debug=False)
