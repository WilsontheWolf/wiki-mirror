FROM python:3.13-slim
RUN apt update && apt install -y --no-install-recommends git curl && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir /app
WORKDIR /app
ADD *.sh *.py /app
RUN ./luals.sh
EXPOSE 3000/tcp
CMD ["./serve.py"]
