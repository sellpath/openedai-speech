FROM python:3.11-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl ffmpeg git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN mkdir -p voices config

COPY requirements.txt /app/
RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt

COPY speech.py openedai.py say.py *.sh README.md LICENSE /app/
COPY config/voice_to_speaker.default.yaml config/pre_process_map.default.yaml /app/config/

ARG PRELOAD_MODEL
ENV PRELOAD_MODEL=${PRELOAD_MODEL}
ENV TTS_HOME=voices
ENV HF_HOME=voices
ENV COQUI_TOS_AGREED=1

CMD bash startup.sh
