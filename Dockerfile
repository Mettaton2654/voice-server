# Используем минимальный Python образ
FROM python:3.11-slim

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# Создаём рабочую директорию
WORKDIR /app

# Копируем только нужные файлы
COPY requirements.txt .
COPY inference.py .
COPY onnx_model.onnx ./models/onnx_model.onnx

# Устанавливаем Python зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Экспортируем порт приложения
EXPOSE 7860

# Запуск инференса
CMD ["python", "inference.py"]

