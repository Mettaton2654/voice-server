FROM jrottenberg/ffmpeg:6.0-scratch

# Устанавливаем только Python
RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
COPY inference.py .
COPY onnx_model.onnx ./models/onnx_model.onnx

RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 7860
CMD ["python3", "inference.py"]

