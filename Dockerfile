# Dockerfile (place at repo root)
FROM python:3.9-slim

WORKDIR /app

# copy requirements and install first to use layer caching
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# copy app
COPY . /app

# expose flask port
EXPOSE 5000

# run app
CMD ["python", "app.py"]
