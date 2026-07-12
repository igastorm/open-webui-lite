# ==========================================
FROM debian:trixie-slim@sha256:4e401d95de7083948053197a9c3913343cd06b706bf15eb6a0c3ccd26f436a0e AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/app/venv/bin:$PATH"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl build-essential binutils && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

COPY requirements.txt /app/requirements.txt

RUN uv venv /app/venv --python 3.12 && \
    uv pip install --python /app/venv torch --index-url https://download.pytorch.org/whl/cpu && \
    uv pip install --python /app/venv -r /app/requirements.txt && \
    uv cache clean

RUN find /app/venv -name "*.so" -exec strip --strip-unneeded {} + && \
    find /app/venv -type d -name "tests" -exec rm -rf {} + && \
    find /app/venv -type d -name "__pycache__" -exec rm -rf {} + && \
    find /app/venv -name "*.pyc" -delete

# ==========================================
FROM debian:trixie-slim@sha256:4e401d95de7083948053197a9c3913343cd06b706bf15eb6a0c3ccd26f436a0e

ENV DEBIAN_FRONTEND=noninteractive
ENV DATA_DIR=/data
ENV HF_HOME=/data/cache/huggingface
ENV SENTENCE_TRANSFORMERS_HOME=/data/cache/sentence_transformers
ENV PATH="/app/venv/bin:$PATH"

COPY --from=builder /app/venv /app/venv
COPY --from=builder /root/.local/share/uv /root/.local/share/uv

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh && mkdir -p /data

RUN apt-get update && apt-get install -y --no-install-recommends \
    tini ca-certificates ffmpeg && rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/log && ln -s /tmp/log /var/log && \
    rm -rf /run && ln -s /tmp/run /run

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD /app/venv/bin/python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')" || exit 1

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
