#!/bin/bash
set -euo pipefail 

mkdir -p /tmp/log
mkdir -p /tmp/run
mkdir -p /tmp/static

mkdir -p /data/cache/huggingface
mkdir -p /data/cache/sentence_transformers

ORIG_STATIC="/app/venv/lib/python3.11/site-packages/open_webui/static"
if [ -d "$ORIG_STATIC" ]; then
    cp -r "$ORIG_STATIC"/* /tmp/static/
fi

if [ -z "$LOG" ]; then
    echo "ERROR: LOG environment variable is not set. Container stopped."
    exit 1
fi

if [ "$LOG" = "on" ] || [ "$LOG" = "ON" ]; then
    exec open-webui serve --port 8080
else
    exec open-webui serve --port 8080 > /dev/null 2>&1
fi
