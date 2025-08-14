FROM python:3.10-slim

# системные зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# копируем только зависимости сначала
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# копируем остальной код
COPY . /app

# выставляем переменные
ENV MODEL_PATH=so-vits-svc/logs/44k/G_40800.pth
ENV CONFIG_PATH=so-vits-svc/config.json

EXPOSE 5000
CMD ["python", "app.py"]