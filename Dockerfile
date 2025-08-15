# ---- Базовый образ ----
FROM python:3.11-slim

# ---- Установка системных зависимостей (минимально) ----
RUN apt-get update && apt-get install -y \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# ---- Копируем проект ----
WORKDIR /app
COPY . /app

# ---- Установка Python-зависимостей ----
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# ---- Если используешь локальный бинарь ffmpeg ----
# COPY ./bin/ffmpeg /usr/local/bin/ffmpeg
# RUN chmod +x /usr/local/bin/ffmpeg

# ---- Порт для Gradio/Flask ----
EXPOSE 7860

# ---- Запуск приложения ----
CMD ["python", "app.py"]
