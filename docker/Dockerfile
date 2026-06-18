FROM debian:trixie-slim@sha256:4e401d95de7083948053197a9c3913343cd06b706bf15eb6a0c3ccd26f436a0e

ENV DEBIAN_FRONTEND=noninteractive
ENV DATA_DIR=/data
ENV HF_HOME=/data/cache/huggingface
ENV SENTENCE_TRANSFORMERS_HOME=/data/cache/sentence_transformers
ENV PATH="/app/venv/bin:$PATH"

COPY requirements.txt /app/requirements.txt
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh && mkdir -p /data

RUN apt-get update && apt-get install -y --no-install-recommends \
    tini ca-certificates curl ffmpeg && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

RUN /root/.local/bin/uv venv /app/venv --python 3.11 && \
    /root/.local/bin/uv pip install --python /app/venv torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    /root/.local/bin/uv pip install --python /app/venv -r /app/requirements.txt && \
    /root/.local/bin/uv cache clean

RUN rm -rf /var/log && ln -s /tmp/log /var/log && \
    rm -rf /run && ln -s /tmp/run /run && \
    rm -rf /app/requirements.txt

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD curl -fsS http://localhost:8080/health -o /dev/null || exit 1

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
