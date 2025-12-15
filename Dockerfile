# n8n Custom Dockerfile for Business Automation
# Alpine Linux + Python 3 + 가상환경 지원 (심링크 수정 버전)
# 빌드 날짜: 2025-12
FROM n8nio/n8n:2.0.0

# ========================================
# 환경 변수 설정
# ========================================
ENV NODE_FUNCTION_ALLOW_BUILTIN=*
ENV NODE_FUNCTION_ALLOW_EXTERNAL=*
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV EXECUTIONS_DATA_PRUNE=true
ENV EXECUTIONS_DATA_MAX_AGE=168
ENV GENERIC_TIMEZONE=Asia/Seoul

# Render/Railway 등 프록시 환경 설정
ENV N8N_PROXY_HOPS=1
ENV N8N_PROTOCOL=https

# ========================================
# Python 3 + 가상환경 설치 (Alpine Linux)
# ========================================
USER root
WORKDIR /tmp

# Python 3 + pip + 빌드 도구 설치
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-setuptools \
    py3-wheel \
    py3-virtualenv \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    libxml2-dev \
    libxslt-dev

# ========================================
# 핵심 수정: python -> python3 심링크 생성
# ========================================
RUN ln -sf /usr/bin/python3 /usr/bin/python

# ========================================
# n8n Python Task Runner 가상환경 생성
# ========================================
RUN python3 -m venv /opt/n8n-python-venv && \
    # python -> python3 심링크 (venv 내부)
    ln -sf /opt/n8n-python-venv/bin/python3 /opt/n8n-python-venv/bin/python && \
    /opt/n8n-python-venv/bin/pip install --upgrade pip setuptools wheel

# 가상환경에 필수 라이브러리 설치
RUN /opt/n8n-python-venv/bin/pip install --no-cache-dir \
    requests \
    httpx \
    aiohttp \
    pandas \
    numpy \
    beautifulsoup4 \
    lxml \
    openpyxl \
    xlsxwriter \
    pyyaml \
    python-dateutil \
    pytz \
    orjson \
    pydantic \
    cryptography \
    pyjwt

# ========================================
# 빌드 시점 검증 (스모크 테스트)
# ========================================
RUN echo "=== Smoke Test ===" && \
    test -f /opt/n8n-python-venv/pyvenv.cfg && echo "✓ pyvenv.cfg exists" && \
    test -x /opt/n8n-python-venv/bin/python && echo "✓ bin/python executable" && \
    test -x /opt/n8n-python-venv/bin/python3 && echo "✓ bin/python3 executable" && \
    /opt/n8n-python-venv/bin/python --version && \
    ls -la /opt/n8n-python-venv/bin/ | head -10

# 가상환경 권한 설정
RUN chown -R node:node /opt/n8n-python-venv

# node 유저로 접근 가능 여부 확인
USER node
RUN /opt/n8n-python-venv/bin/python -V && /opt/n8n-python-venv/bin/pip -V
USER root

# 빌드 도구 정리
RUN apk del gcc musl-dev python3-dev libffi-dev libxml2-dev libxslt-dev || true

# ========================================
# JavaScript 패키지 설치
# ========================================
RUN npm install -g \
    axios got node-fetch@2 \
    moment dayjs date-fns luxon \
    lodash uuid nanoid \
    cheerio xml2js fast-xml-parser sanitize-html \
    papaparse xlsx js-yaml ajv \
    crypto-js bcryptjs jsonwebtoken jose \
    handlebars mustache ejs \
    jszip archiver \
    qrcode iconv-lite pdf-lib zod \
    bottleneck p-limit p-retry pino \
    decimal.js big.js \
    validator slugify html-to-text

# ========================================
# 최종 설정
# ========================================
USER node
WORKDIR /home/node

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

EXPOSE 5678
