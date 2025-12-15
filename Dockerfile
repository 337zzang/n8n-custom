# n8n Custom Dockerfile for Business Automation
# Alpine Linux + Python 3 지원
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

# Python Task Runner 설정
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_RUNNERS_MODE=internal

# ========================================
# Python 3 설치 (Alpine Linux)
# ========================================
USER root
WORKDIR /tmp

# Python 3 + pip + 빌드 도구 설치
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-setuptools \
    py3-wheel \
    # numpy/pandas 빌드에 필요한 패키지
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    # lxml 빌드에 필요
    libxml2-dev \
    libxslt-dev

# Python 필수 라이브러리 설치
RUN pip3 install --no-cache-dir --break-system-packages \
    # HTTP/API 통신
    requests \
    httpx \
    aiohttp \
    # 데이터 처리
    pandas \
    numpy \
    # HTML/XML 파싱
    beautifulsoup4 \
    lxml \
    # Excel 처리
    openpyxl \
    xlsxwriter \
    # 유틸리티
    pyyaml \
    python-dateutil \
    pytz \
    # JSON 처리
    orjson \
    pydantic \
    # 암호화
    cryptography \
    pyjwt

# 빌드 도구 정리 (이미지 크기 최소화)
RUN apk del gcc musl-dev python3-dev libffi-dev libxml2-dev libxslt-dev || true

# ========================================
# JavaScript 패키지 설치 (순수 JavaScript만)
# ========================================

# 1. HTTP/API 통신 (3개)
RUN npm install -g \
    axios \
    got \
    node-fetch@2

# 2. 날짜/시간 처리 (4개)
RUN npm install -g \
    moment \
    dayjs \
    date-fns \
    luxon

# 3. 데이터 처리/유틸리티 (3개)
RUN npm install -g \
    lodash \
    uuid \
    nanoid

# 4. HTML/XML 파싱 (4개)
RUN npm install -g \
    cheerio \
    xml2js \
    fast-xml-parser \
    sanitize-html

# 5. CSV/Excel/데이터 포맷 (4개)
RUN npm install -g \
    papaparse \
    xlsx \
    js-yaml \
    ajv

# 6. 암호화/인증 (4개)
RUN npm install -g \
    crypto-js \
    bcryptjs \
    jsonwebtoken \
    jose

# 7. 템플릿 엔진 (3개)
RUN npm install -g \
    handlebars \
    mustache \
    ejs

# 8. 압축/아카이브 (2개)
RUN npm install -g \
    jszip \
    archiver

# 9. QR코드/PDF/유틸 (4개)
RUN npm install -g \
    qrcode \
    iconv-lite \
    pdf-lib \
    zod

# 10. 속도 제한/동시성/재시도 (4개)
RUN npm install -g \
    bottleneck \
    p-limit \
    p-retry \
    pino

# 11. 금융/수학 계산 (2개)
RUN npm install -g \
    decimal.js \
    big.js

# 12. 문자열/검증 (3개)
RUN npm install -g \
    validator \
    slugify \
    html-to-text

# ========================================
# 사용자 및 작업 디렉토리 복원
# ========================================
USER node
WORKDIR /home/node

# ========================================
# 헬스체크
# ========================================
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

EXPOSE 5678
