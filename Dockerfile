# n8n Custom Dockerfile for Business Automation
# JavaScript Only (Python 제거 - External mode 필요하므로)
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
# JavaScript 패키지 설치
# ========================================
USER root
WORKDIR /tmp

# 1. HTTP/API 통신
RUN npm install -g axios got node-fetch@2

# 2. 날짜/시간 처리
RUN npm install -g moment dayjs date-fns luxon

# 3. 데이터 처리/유틸리티 (Pandas 스타일!)
RUN npm install -g lodash uuid nanoid danfojs-node arquero

# 4. HTML/XML 파싱
RUN npm install -g cheerio xml2js fast-xml-parser sanitize-html

# 5. CSV/Excel/데이터 포맷
RUN npm install -g papaparse xlsx js-yaml ajv

# 6. 암호화/인증
RUN npm install -g crypto-js bcryptjs jsonwebtoken jose

# 7. 템플릿 엔진
RUN npm install -g handlebars mustache ejs

# 8. 압축/아카이브
RUN npm install -g jszip archiver

# 9. QR코드/PDF/유틸
RUN npm install -g qrcode iconv-lite pdf-lib zod

# 10. 속도 제한/동시성/재시도
RUN npm install -g bottleneck p-limit p-retry pino

# 11. 금융/수학 계산
RUN npm install -g decimal.js big.js

# 12. 문자열/검증
RUN npm install -g validator slugify html-to-text

# ========================================
# 최종 설정
# ========================================
USER node
WORKDIR /home/node

# ========================================
# 헬스체크
# ========================================
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

EXPOSE 5678
