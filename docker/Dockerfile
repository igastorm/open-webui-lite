FROM debian:trixie-slim@sha256:b6e2a152f22a40ff69d92cb397223c906017e1391a73c952b588e51af8883bf8

ENV DEBIAN_FRONTEND=noninteractive
ENV DATA_DIR=/data
ENV HF_HOME=/data/cache/huggingface
ENV SENTENCE_TRANSFORMERS_HOME=/data/cache/sentence_transformers
ENV PATH="/app/venv/bin:$PATH"

RUN apt-get update && apt-get install -y --no-install-recommends \
    tini ca-certificates curl ffmpeg && rm -rf /var/lib/apt/lists/* && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    /root/.local/bin/uv venv /app/venv --python 3.11 && \
    /root/.local/bin/uv pip install --python /app/venv torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    /root/.local/bin/uv pip install --python /app/venv open-webui && \
    /root/.local/bin/uv cache clean && \
    rm -rf /var/log && ln -s /tmp/log /var/log && \
    rm -rf /run && ln -s /tmp/run /run && \
    mkdir -p /data

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD curl -fsS http://localhost:8080/health -o /dev/null || exit 1

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
