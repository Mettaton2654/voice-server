# ---- Stage 1: минимальный Python с pip ----
FROM python:3.11-slim

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем Python-зависимости для инференса
RUN pip install --no-cache-dir \
    numpy==1.23.5 \
    scipy==1.10.0 \
    soundfile==0.12.1 \
    torch==2.2.0+cpu \
    torchaudio==2.2.0+cpu \
    onnx \
    onnxruntime \
    onnxsim \
    pyyaml \
    einops \
    edge_tts \
    flask \
    flask_cors \
    gradio>=3.7.0 \
    loguru \
    rich

# Копируем модель и скрипты инференса в контейнер
WORKDIR /app
COPY ./model /app/model
COPY ./inference.py /app/inference.py

# Запуск инференса
CMD ["python", "inference.py"]

EXPOSE 7860

# ---- Запуск приложения ----
CMD ["python", "app.py"]
