# Используем легкий Python-образ с ffmpeg сразу
FROM jrottenberg/ffmpeg:6.0-slim

# Минимальные системные зависимости
RUN apt-get update && apt-get install -y libsndfile1 && rm -rf /var/lib/apt/lists/*

# Устанавливаем Python и pip
RUN apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*

# Устанавливаем Python-зависимости (CPU-only)
RUN pip install --no-cache-dir \
    numpy==1.23.5 \
    scipy==1.10.0 \
    soundfile==0.12.1 \
    torch==2.2.0+cpu \
    torchaudio==2.2.0+cpu \
    onnx \
    onnxruntime \
    pyyaml \
    einops \
    edge_tts \
    flask \
    flask_cors \
    gradio>=3.7.0 \
    loguru \
    rich

# Рабочая директория
WORKDIR /app
COPY ./model /app/model
COPY ./inference.py /app/inference.py

CMD ["python3", "inference.py"]
