FROM python:3.13-slim
RUN apt update && apt install -y --no-install-recommends git && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir /app
WORKDIR /app
EXPOSE 3000/tcp
ADD *.sh *.py /app
CMD ["./serve.py"]
