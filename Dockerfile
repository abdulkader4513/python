# Dockerfile

FROM python:3.8-slim-buster

RUN apt-get update && apt-get install -y \
  tesseract-ocr \
  libtesseract-dev

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

EXPOSE 4000

CMD ["python", "app.py"]
