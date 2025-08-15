# Используем предсобранный PyTorch образ с CUDA (ускоряет сборку)
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

# Обновляем pip и устанавливаем базовые зависимости
RUN pip install --upgrade pip setuptools wheel

# Устанавливаем нужные Python-пакеты
RUN pip install \
    gradio>=3.7.0 \
    numpy==1.23.5 \
    torchcrepe \
    torchaudio \
    ffmpeg-python \
    SoundFile==0.12.1 \
    pyyaml \
    einops

# Копируем проект в контейнер
WORKDIR /app
COPY . /app

# Указываем команду запуска (замени на свою, например запуск сервера Gradio)
CMD ["python", "app.py"]

