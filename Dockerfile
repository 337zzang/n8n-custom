# n8n Custom Dockerfile for Business Automation
# Version: 2.0.0-enterprise
# Updated: 2025-12

FROM n8nio/n8n:2.0.0

# ============================================
# 환경변수 설정
# ============================================
ENV NODE_FUNCTION_ALLOW_BUILTIN=*
ENV NODE_FUNCTION_ALLOW_EXTERNAL=axios,lodash,moment,dayjs,cheerio,node-fetch,uuid,crypto-js,xml2js,fast-xml-parser,csv-parser,papaparse,xlsx,exceljs,pdf-lib,pdfkit,handlebars,mustache,jsonwebtoken,bcryptjs,sharp,archiver,jszip,dotenv,qs,form-data,mime-types,iconv-lite,date-fns,numeral,validator,sanitize-html,markdown-it,marked,jose,nanoid,slugify
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV N8N_HIRING_BANNER_ENABLED=false
ENV EXECUTIONS_DATA_PRUNE=true
ENV EXECUTIONS_DATA_MAX_AGE=168
ENV GENERIC_TIMEZONE=Asia/Seoul

# ============================================
# npm 패키지 설치
# ============================================
USER root

# 시스템 의존성 (이미지 처리, PDF 등)
RUN apk add --no-cache \
    python3 \
    py3-pip \
    build-base \
    cairo-dev \
    pango-dev \
    jpeg-dev \
    giflib-dev \
    librsvg-dev \
    pixman-dev

# npm 패키지 설치 (업무자동화 필수)
WORKDIR /usr/local/lib/node_modules/n8n

RUN npm install --save \
    # === HTTP & API ===
    axios@1.6.0 \
    node-fetch@2.7.0 \
    form-data@4.0.0 \
    qs@6.11.2 \
    # === 데이터 처리 ===
    lodash@4.17.21 \
    underscore@1.13.6 \
    # === 날짜/시간 ===
    moment@2.30.1 \
    moment-timezone@0.5.45 \
    dayjs@1.11.10 \
    date-fns@3.3.1 \
    # === 문자열/숫자 ===
    numeral@2.0.6 \
    validator@13.11.0 \
    slugify@1.6.6 \
    nanoid@3.3.7 \
    uuid@9.0.1 \
    # === HTML/XML 파싱 ===
    cheerio@1.0.0-rc.12 \
    fast-xml-parser@4.3.4 \
    xml2js@0.6.2 \
    sanitize-html@2.12.1 \
    # === CSV/Excel ===
    csv-parser@3.0.0 \
    papaparse@5.4.1 \
    xlsx@0.18.5 \
    exceljs@4.4.0 \
    # === PDF ===
    pdf-lib@1.17.1 \
    pdfkit@0.14.0 \
    # === 이미지 ===
    sharp@0.33.2 \
    jimp@0.22.12 \
    # === 압축 ===
    archiver@6.0.1 \
    jszip@3.10.1 \
    # === 암호화/보안 ===
    crypto-js@4.2.0 \
    bcryptjs@2.4.3 \
    jsonwebtoken@9.0.2 \
    jose@5.2.2 \
    # === 템플릿 ===
    handlebars@4.7.8 \
    mustache@4.2.0 \
    ejs@3.1.9 \
    # === 마크다운 ===
    markdown-it@14.0.0 \
    marked@11.2.0 \
    # === 유틸리티 ===
    dotenv@16.4.1 \
    mime-types@2.1.35 \
    iconv-lite@0.6.3 \
    # === 바코드/QR ===
    qrcode@1.5.3 \
    bwip-js@4.1.1 \
    # === 문서 생성 ===
    docx@8.5.0

# ============================================
# Python 패키지 (Code 노드 Python용)
# ============================================
RUN pip3 install --no-cache-dir --break-system-packages \
    requests \
    pandas \
    openpyxl \
    xlrd \
    beautifulsoup4 \
    lxml \
    python-dateutil \
    pytz \
    Pillow \
    PyPDF2 \
    reportlab \
    python-docx \
    pyyaml \
    boto3 \
    google-api-python-client \
    slack-sdk \
    python-telegram-bot

# ============================================
# 정리 및 권한 설정
# ============================================
RUN apk del build-base && \
    rm -rf /var/cache/apk/* /tmp/* /root/.npm

USER node
WORKDIR /home/node

# 헬스체크
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

EXPOSE 5678
