# Whisper n8n API

Este projeto implementa uma API de transcrição de áudio baseada no modelo Whisper, utilizando FastAPI e `faster_whisper`. É projetado para ser integrado em workflows do n8n via Coolify, permitindo automação de transcrição de arquivos de áudio.

## Descrição

A API expõe um endpoint simples para transcrever áudio em texto. Ela usa o modelo "small" do Whisper por padrão (configurável via variável de ambiente), rodando em um contêiner Docker para fácil implantação.

### Funcionalidades
- Transcrição de arquivos de áudio (suporta formatos comuns via FFmpeg).
- API RESTful com FastAPI.
- Otimizada para CPU (usando `int8` para eficiência).
- Integração direta com n8n para workflows de automação.

## Pré-requisitos

- Docker e Docker Compose instalados.
- Acesso a um ambiente Coolify para implantação (opcional, mas recomendado para produção).
- n8n configurado para consumir APIs HTTP.

## Instalação e Execução Local

1. Clone ou baixe o repositório.
2. Navegue para a pasta do projeto: `cd whisper_n8n`.
3. Execute o Docker Compose:
   ```
   docker-compose up --build
   ```
4. A API estará disponível em `http://localhost:5001`.

## Implantação no Coolify

1. Faça upload do `docker-compose.yml` e da pasta `whisper/` para o seu projeto no Coolify.
2. Configure a rede `evolution-net` se necessário (para integração com outros serviços).
3. Defina variáveis de ambiente, como `ASR_MODEL` (ex.: "base", "small", "medium").
4. Implante via painel do Coolify. A API será acessível na porta 5001 (ou configure um domínio).

### Observações para Coolify
- Certifique-se de que a rede `evolution-net` seja compartilhada com o n8n se estiver no mesmo projeto.
- Monitore recursos (CPU/RAM), pois modelos Whisper podem ser intensivos.
- Adicione healthchecks no Docker Compose para melhor monitoramento.

## Integração com n8n

1. No n8n, adicione um nó "HTTP Request".
2. Configure o método como POST e a URL como `http://<seu-dominio-coolify>:5001/transcribe`.
3. Envie o arquivo de áudio como multipart/form-data (campo "file").
4. Receba a resposta JSON com o texto transcrito e processe em nós subsequentes (ex.: salvar em banco ou enviar notificação).

Exemplo de workflow n8n:
- Nó de entrada: Upload de arquivo.
- Nó HTTP Request: Chama a API de transcrição.
- Nó de saída: Processa o texto (ex.: análise de sentimento ou armazenamento).

## API Endpoints

### POST /transcribe
Transcreve um arquivo de áudio enviado.

- **Parâmetros**:
  - `file`: Arquivo de áudio (multipart/form-data).
- **Resposta**:
  - JSON: `{"text": "Texto transcrito aqui..."}`
- **Exemplo de uso**:
  ```
  curl -X POST -F "file=@audio.wav" http://localhost:5001/transcribe
  ```

## Configuração

- **Modelo Whisper**: Definido via variável de ambiente `ASR_MODEL` (padrão: "small"). Modelos maiores (ex.: "medium") oferecem melhor precisão, mas consomem mais recursos.
- **Porta**: 8000 interna no contêiner, mapeada para 5001 no host.

## Dependências

Listadas em `whisper/requirements.txt`:
- fastapi
- uvicorn
- faster-whisper
- ctranslate2==3.24.0
- python-multipart

## Estrutura do Projeto

```
whisper_n8n/
├── docker-compose.yml
├── Dockerfile (raiz, opcional)
├── whisper/
│   ├── api_server.py
│   ├── requirements.txt
│   └── Dockerfile
```

## Contribuição

1. Faça um fork do projeto.
2. Crie uma branch para suas mudanças.
3. Teste localmente com Docker.
4. Envie um pull request.

## Licença

Este projeto é open-source. Use sob sua responsabilidade.

## Suporte

Para dúvidas, abra uma issue no repositório ou consulte a documentação do FastAPI/Whisper.
