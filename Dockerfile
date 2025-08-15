# --- Stage 1: Install dependencies ---
FROM python:3.11-slim as builder

# Обновление и установка необходимых системных пакетов
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ffmpeg \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Установка pip последней версии
RUN pip install --upgrade "pip<24.1"


# Копируем только файл зависимостей
WORKDIR /app
COPY requirements.txt .

# Установка зависимостей
RUN pip install --no-cache-dir -r requirements.txt

# --- Stage 2: Сборка финального образа ---
FROM python:3.11-slim

WORKDIR /app

# Копируем зависимости из builder stage
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Копируем исходный код проекта (без больших файлов)
COPY . .

# Устанавливаем переменные окружения
ENV VOICE_SERVER_URL=https://<project>.up.railway.app/speak

# Expose порт, который используется FastAPI/Flask
EXPOSE 8000

# Команда для запуска сервера (замени на актуальную)
CMD ["python", "server.py"]
