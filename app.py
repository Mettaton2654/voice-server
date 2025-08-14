from flask import Flask, request, send_file
import subprocess
import os
import uuid

MODEL_PATH = "so-vits-svc/logs/44k/G_40800.pth"
CONFIG_PATH = "so-vits-svc/logs/44k/config.json"

app = Flask(__name__)

@app.route("/speak", methods=["POST"])
def speak():
    text = request.form.get("text")
    if not text:
        return {"error": "No text provided"}, 400

    tmp_id = uuid.uuid4()

    # 1. Генерируем базовый TTS в WAV (тут можно заменить на piper-tts)
    tts_wav = f"tmp_{tmp_id}.wav"
    subprocess.run([
        "tts",  # или "piper" если ставить piper-tts
        "--text", text,
        "--out_path", tts_wav
    ])

    # 2. Прогоняем через So-VITS-SVC
    output_wav = f"voice_{tmp_id}.wav"
    subprocess.run([
        "python", "so-vits-svc/inference_main.py",
        "-m", MODEL_PATH,
        "-c", CONFIG_PATH,
        "-n", tts_wav,
        "-o", output_wav,
        "--tran", "0"
    ])

    # 3. Конвертируем в OGG для Telegram
    output_ogg = output_wav.replace(".wav", ".ogg")
    subprocess.run([
        "ffmpeg", "-i", output_wav, "-c:a", "libopus", output_ogg
    ])

    return send_file(output_ogg, mimetype="audio/ogg")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
