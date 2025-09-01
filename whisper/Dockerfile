# PASSO 1: Usamos a base Ubuntu 22.04 LTS - um ambiente super estável e completo.
FROM ubuntu:22.04

# Evita que o instalador faça perguntas durante o build
ENV DEBIAN_FRONTEND=noninteractive

# PASSO 2: Instalamos o Python 3.10, o pip, e todas as nossas ferramentas.
# No Ubuntu 22.04, o pacote 'prelink' está disponível.
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    ffmpeg \
    wget \
    prelink \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# PASSO 3: Definimos a pasta de trabalho e copiamos os arquivos do nosso projeto
WORKDIR /app
COPY requirements.txt .
COPY api_server.py .

# PASSO 4: Instalamos as dependências do Python
RUN pip3 install --no-cache-dir -r requirements.txt

# PASSO 5: Aplicamos a correção de segurança com o 'execstack'
RUN find /usr/local/lib -name "libctranslate2*.so*" -exec execstack -c {} \;

# PASSO 6: Comando para iniciar a API (usando a porta 8000 interna)
EXPOSE 8000
CMD ["uvicorn", "api_server:app", "--host", "0.0.0.0", "--port", "8000"]