# Usar uma base de sistema operacional (Ubuntu)
FROM ubuntu:22.04

# Instalar todas as ferramentas necessárias (compilador, git, ffmpeg, wget)
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    ffmpeg \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Definir a pasta de trabalho dentro do container
WORKDIR /app

# Baixar o código-fonte do whisper.cpp e o modelo de IA
RUN git clone https://github.com/ggerganov/whisper.cpp.git .
RUN ./models/download-ggml-model.sh base

# Compilar o programa do servidor usando cmake (o método correto e mais robusto)
RUN cmake -B build
RUN cmake --build build --config Release

# Expor a porta que o servidor vai usar
EXPOSE 8080

# Comando para iniciar o servidor (o caminho para o executável mudou após a compilação com cmake)
CMD ["./build/bin/server", "-m", "models/ggml-base.bin", "--host", "0.0.0.0", "--port", "8080"]